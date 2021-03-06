
# This is all temporary and horrible while we have a monorepo
v3_url = "https://github.com/exercism/v3"
repo = Git::Track.new(v3_url, :ruby)

# This updates it once before we stub it below
repo.send(:repo).send(:rugged_repo)

# Adding this is many OOM faster. It's horrible and temporary
# but useful for now
module Git
  class Repository
    def rugged_repo
      Rugged::Repository.new(repo_dir)
    end
  end
end

track_slugs = []
tree = repo.send(:repo).read_tree(repo.send(:repo).head_commit, "languages/")
tree.each_tree { |obj| track_slugs << obj[:name] }

puts track_slugs

track_slugs.each do |track_slug|
  if Track.find_by(slug: track_slug)
    puts "Track already added: #{track_slug}"
    next
  end

  puts "Adding Track: #{track_slug}"
  track = Track.create!(slug: track_slug, title: track_slug.titleize, repo_url: v3_url)

  begin
    #track.update(title: track.repo.config[:language])
    track.repo.config[:exercises][:concept].each do |exercise_config|
      ce = ConceptExercise.create!(
        track: track,
        uuid: exercise_config[:uuid], 
        slug: exercise_config[:slug],
        title: exercise_config[:slug].titleize,
      )
      #exercise_config[:concepts].each do |concept|
      #  ce.concepts << Track::Concept.find_or_create_by!(uuid: SecureRandom.uuid, name: concept, track: track)
      #end
      exercise_config[:prerequisites].each do |concept|
        ce.prerequisites << Track::Concept.find_or_create_by!(uuid: SecureRandom.uuid, name: concept, track: track)
      end
    end
  rescue => e
    puts "Error creating concept exercises for Track #{track_slug}: #{e}"
  end
end


puts "Creating User iHiD"
user = User.create!(handle: 'iHiD') unless User.find_by(handle: 'iHiD')
UserTrack.create!(user: user, track: Track.find_by_slug!("ruby"))
auth_token = user.auth_tokens.create!

puts ""
puts "To use the CLI locally, run: "
puts "exercism configure -a http://localhost:3020/api/v1 -t #{auth_token.token}"
puts ""

=begin
concept_exercise = ConceptExercise.create!(track: track, uuid: SecureRandom.uuid, slug: "numbers", prerequisites: [], title: "numbers")
practice_exercise = PracticeExercise.create!(track: track, uuid: SecureRandom.uuid, slug: "bob", prerequisites: [], title: "bob")
concept_solution = ConceptSolution.create!(exercise: concept_exercise, user: user, uuid: SecureRandom.uuid)
practice_solution = PracticeSolution.create!(exercise: practice_exercise, user: user, uuid: SecureRandom.uuid)

Iteration.create!(
  solution: concept_solution,
  uuid: SecureRandom.uuid,
  submitted_via: "cli"
)
=end

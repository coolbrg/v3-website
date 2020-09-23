class Test::Components::TrackListsController < ApplicationController
  def show
    @tracks = [
      {
        id: 2,
        trackTitle: "Ruby",
        trackIconUrl: "https://assets.exercism.io/tracks/ruby-hex-white.png",
        exerciseCount: 20,
        conceptExerciseCount: 10,
        practiceExerciseCount: 10,
        studentCount: 10,
        isNew: true,
        isJoined: true,
        tags: ["OOP", "Web Dev"],
        completedExerciseCount: 15,
        trackProgressPercentage: "66.67",
        url: "https://exercism.io/tracks/1"
      },
      {
        id: 3,
        trackTitle: "Go",
        trackIconUrl: "https://assets.exercism.io/tracks/go-hex-white.png",
        exerciseCount: 15,
        conceptExerciseCount: 10,
        practiceExerciseCount: 5,
        studentCount: 20,
        isNew: false,
        isJoined: false,
        tags: ["Systems"],
        completedExerciseCount: 0,
        trackProgressPercentage: 0,
        url: "https://exercism.io/tracks/3"
      }
    ]
  end
end
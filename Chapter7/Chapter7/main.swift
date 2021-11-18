import StatisticalSwift

var raters = DataLoader.load(
  MovieWatcher.self,
  from: .movieRatings
)

let user = raters.remove(at: 0)

let recommendations = MovieRecommender
  .recommend(
    movies: 5,
    for: user,
    from: raters,
    neighbors: 30
  )

print(
  """
  Recommended movies for user \(user.id):
  
  \(
    recommendations
      .joined(separator: "\n")
  )
  
  """
)

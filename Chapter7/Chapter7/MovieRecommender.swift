import Accelerate
import StatisticalSwift
import StatKit

enum MovieRecommender {
  static func recommend(
    movies: Int,
    for someone: MovieWatcher,
    from others: [MovieWatcher],
    neighbors: Int
  ) -> [String] {
    
    let similarUsers = getMostSimilar(
      to: someone,
      from: others,
      neighbors: neighbors
    )
    
    let ratingDist = ratingDistributions(
      from: similarUsers,
      movieCount: someone.ratings.count,
      neighbors: neighbors
    )
    
    let expectations = expectedRatings(
      using: ratingDist
    )
    
    return getTopRated(
      movies: movies,
      for: someone,
      expectations: expectations
    )
  }
  
  private static func getMostSimilar(
    to someone: MovieWatcher,
    from others: [MovieWatcher],
    neighbors: Int
  ) -> [MovieWatcher] {
    
    let similarities = others
      .map { other in
        similarity(lhs: someone, rhs: other)
      }
    
    let mostSimilar = similarities
      .enumerated()
      .sorted { lhs, rhs in
        lhs.element < rhs.element
      }
      .dropLast(others.count - neighbors)
      .map { offset, element in
        others[offset]
      }
    
    return mostSimilar
  }
  
  private static func ratingDistributions(
    from similarUsers: [MovieWatcher],
    movieCount: Int,
    neighbors: Int
  ) -> [[Double]] {
    
    let N = neighbors.realValue
    let pseudoCount = 1.0
    let numRatings = 6
    let total = N + numRatings.realValue * pseudoCount
    
    let columns = [Double](
      repeating: pseudoCount,
      count: numRatings
    )
    
    let ratingMatrix = [[Double]](
      repeating: columns,
      count: movieCount
    )
    
    let counts = similarUsers
      .reduce(into: ratingMatrix) { matrix, user in
        user.ratings
          .enumerated()
          .forEach { movie, rating in
            matrix[movie][Int(rating)] += 1
          }
      }
    
    return counts
      .map { movieRatings in
        movieRatings.map { rating in
          rating / total
        }
      }
  }
  
  private static func expectedRatings(
    using ratingsDist: [[Double]]
  ) -> [Double] {
    
    ratingsDist
      .map { distribution -> Double in
        let bayesDenom = 1 - distribution[0]
        
        return distribution
          .enumerated()
          .dropFirst()
          .reduce(into: 0.0) { expectation, args in
            let (intRating, prob) = args
            let rating = intRating.realValue
            expectation += rating * prob / bayesDenom
          }
      }
  }
  
  private static func getTopRated(
    movies: Int,
    for someone: MovieWatcher,
    expectations: [Double]
  ) -> [String] {
    
    expectations
      .enumerated()
      .sorted { lhs, rhs in
        if someone.ratings[lhs.offset] != 0 {
          return false
        }
        if someone.ratings[rhs.offset] != 0 {
          return true
        }
        return lhs.element > rhs.element
      }
      .dropLast(expectations.count - movies)
      .map { index, _ in
        someone.titles[index]
      }
  }
  
  private static func similarity(
    lhs: MovieWatcher,
    rhs: MovieWatcher
  ) -> Double {
    
    var (left, right) = (lhs.ratings, rhs.ratings)
    
    for index in 0 ..< left.count {
      if left[index] == 0 {
        right[index] = 5
      } else if right[index] == 0 {
        left[index] = 5
      }
    }
    
    return vDSP
      .distanceSquared(
        left,
        right
      )
  }
}

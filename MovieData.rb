class MovieData


  def initialize(dir)
    if dir == "ml-100k"
      @training_set = open("u.data").read.split(/[\t,\n]/);
      @test_set = nil
      @movies = []
      @users = []
    end
  end


  def initialize(dir, u)
    if dir == "ml-100k"
      @training_set = open("#{u}.base").read.split(/[\t,\n]/);
      @test_set = open("#{u}.test").read.split(/[\t,\n]/);
      @movies = []
      @users = []

      # This is the top most similar users to user 1
      # Otherwise most_similar will need to be run before predict()
      @most_similar_user = [723, 700, 124, 584, 737, 55, 571, 51, 202, 742]
    end
  end


  def rating(user, movie)
    i = 0

    while i < @training_set.length
      # Checks if that user in the array is user
      if @training_set[i].to_i == user
        # If it is that yser it checks to see if it's for the
        # movie asked for
        if @training_set[i+1].to_i == movie
          # returns the rating that user gave movie
          return @training_set[i+2].to_i
        end
      end

      i += 4
    end

    # If there was no rating it returns 0
    return 0
  end


  def predict(user, movie)

    i = 0

    predicted_rating = 0

    # Will run until a user has rated the specified movie
    while rating(@most_similar_user[i], movie) != 0

      # Checks how similar the user is to who is in the most_similar list
      if similarity(@most_similar_user[i], user) == 1000

        predicted_rating = rating(@most_similar_user[i], movie)
        return predicted_rating.to_i

      # if the user is less similar to the user in the array it will take
      # that into consideration when predicting the rating for a movie by user
      elsif similarity(@most_similar_user[i], user) >= 800

        if rating(@most_similar_user[i], movie) + 0.5 > 5

          predicted_rating = rating(@most_similar_user[i], movie) - 0.5
          return predicted_rating.to_i

        else

          predicted_rating = rating(@most_similar_user[i], movie) + 0.5
          return predicted_rating.to_i

        end

      elsif similarity(@most_similar_user[i], user) >= 600

        if rating(@most_similar_user[i], movie) + 1 > 5

          predicted_rating = rating(@most_similar_user[i], movie) - 1
          return predicted_rating.to_i

        else

          predicted_rating = rating(@most_similar_user[i], movie) + 1
          return predicted_rating.to_i

        end

      elsif similarity(@most_similar_user[i], user) >= 400

        if rating(@most_similar_user[i], movie) + 1.5 > 5

          predicted_rating = rating(@most_similar_user[i], movie) - 1.5
          return predicted_rating.to_i

        else

          predicted_rating = rating(@most_similar_user[i], movie) + 1.5
          return predicted_rating.to_i

        end

      elsif similarity(@most_similar_user[i], user) >= 200

        if rating(@most_similar_user[i], movie) + 2 > 5

          predicted_rating = rating(@most_similar_user[i], movie) - 2
          return predicted_rating.to_i

        else

          predicted_rating = rating(@most_similar_user[i], movie) + 2
          return predicted_rating.to_i

        end

      else

        if rating(@most_similar_user[i], movie) + 2.5 > 5

          predicted_rating = rating(@most_similar_user[i], movie) - 2.5
          return predicted_rating.to_i

        else

          predicted_rating = rating(@most_similar_user[i], movie) + 2.5
          return predicted_rating.to_i

        end

      end

      i += 1

    end

  end


  def movies(user)

    i = 0
    temp = []

    # runs through the data looking for any movie rated by user
    while i < @training_set.length
      if @training_set[i].to_i == user
        temp.push(@training_set[i+1])
      end

      i += 4
    end

    # returns the array of movies rated by user
    return temp
  end


  def viewers(movie)

    i = 1
    temp = []

    # loops through the data looking for movie
    # it will then save every user that rated movie
    while i < @training_set.length
      if @training_set[i].to_i == movie
        temp.push(@training_set[i-1])
      end

      i += 4
    end

    # this will return the array
    return temp
  end


  # runs the test class
  def run_test()

    require_relative 'MovieTest'

    z = MovieTest.new()

  end


  # returns the data being used
  def get_training_set()
    return @training_set
  end


  def similarity(user1, user2)
    i = 0
    j = 0

    # every user starts off with 100 rating, which will slowly decline
    # based off of movie ratings
    similarity_rating = 1000

    # loops through the dataset getting the movie IDs and ratings
    while i < @training_set.length
      if @training_set[i].to_i == user1
        user1_movie_id = @training_set[i+1].to_i
        user1_rating = @training_set[i+2].to_i
        j = i
        flag = false
        while j < @training_set.length
          if @training_set[j].to_i == user2
            if @training_set[j+1].to_i == user1_movie_id
              flag = true
              user2_rating = @training_set[j+2].to_i
              dif_in_ratings = user1_rating - user2_rating
              dif_in_ratings = dif_in_ratings.abs
              similarity_rating = similarity_rating - dif_in_ratings / 2
              break
            end
          end

          j += 4
        end

        if !flag
          similarity_rating -= user1_rating
        end
      end

      i += 4
    end

    i = 0
    j = 0

    while i <= @training_set.length-1
      if @training_set[i].to_i == user2
        user2_movie_id = @training_set[i+1].to_i
        user2_rating = @training_set[i+2].to_i
        j = i
        flag = false
        while j <= @training_set.length-1
          if @training_set[j].to_i == user1
            if @training_set[j+1].to_i == user2_movie_id
              flag = true
              user1_rating = @training_set[j+2].to_i
              dif_in_ratings = user2_rating - user1_rating
              dif_in_ratings = dif_in_ratings.abs
              similarity_rating = similarity_rating - dif_in_ratings / 2
              break
            end
          end

          j += 4
        end

        if !flag
          similarity_rating -= user2_rating
        end
      end

      i += 4
    end

    return similarity_rating

  end
end

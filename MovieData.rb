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
      #@most_similar_user = [723, 700, 124, 584, 737, 55, 571, 51, 202, 742]
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

# THE REST OF THE CODE IS FROM PART 1

  def load_data()

    @training_set = open("u.data").read.split(/[\t,\n]/)

    @popular_ratings = []
    @popular_movies = []

    @most_similar_users = []
    @most_similar_ratings = []

    # 0 + 4n is user_id
    # 1 + 4n is movie_id
    # 2 + 4n is rating
    # 3 + 4n is timestamp
  end


  def popularity(movie_id)
    # creates some variables to be used later
    ratings_total = 0
    number_of_ratings = 0
    i = 1

    # loops through dataset by 4 to pick out the
    # movies and ratings
    while i <= @training_set.length-1
      if @training_set[i].to_i == movie_id
        ratings_total += @training_set[i+1].to_i
        number_of_ratings += 1
      end

      i += 4
    end

    # calculates the average rating per movie
    avg_rating = ratings_total / number_of_ratings
    avg_rating_for_return = avg_rating

    j = 0

    # loops through the entire number of movies
    while j < 1682
      # When this gets to an unused spot in the array
      # it will add in the move and rating to their
      # appropriate arrays
      if @popular_ratings[j].nil?
        @popular_ratings.push(avg_rating)
        @popular_movies.push(movie_id)

        # breaks the while loop or the arrays would be filled
        # with 1 movie and 1 rating but for the entirety of the arrays
        break

      else
        # adds in the movie and its rating in the appropriate locations
        # this will also shift all elements after the location where the new
        # movie is added into the array
        if @popular_ratings[j] < avg_rating
          temp_rating = @popular_ratings[j]
          temp_movie = @popular_movies[j]

          @popular_ratings[j] = avg_rating
          @popular_movies[j] = movie_id

          avg_rating = temp_rating
          movie_id = temp_movie
        end
      end

      j += 1
    end

    return avg_rating_for_return
  end


  # outputs the top 10 and bottom 10 movies based on popularity
  def popularity_list()
    i = 0
    j = 1672
    k = 1

    while k <= 1682
      temp_rate = popularity(k)
      k += 1
    end

    puts "The top 10 movies are"

    while i <= 9
      puts @popular_movies[i]

      i += 1
    end

    puts ""

    puts "The bottom 10 movies are"

    while j <= @popular_movies.length-1
      puts @popular_movies[j]

      j += 1
    end
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


  def most_similar(u)
    @most_similar_users = []
    @most_similar_ratings = []
    i = 1

    while i <= 943
      if u != i
        new_rating = similarity(u,i)
        j = 0
        k = i
        while j <= 942
          if @most_similar_users[j].nil?
            @most_similar_users.push(k)
            @most_similar_ratings.push(new_rating)
            break
          else
            if @most_similar_ratings[j] < new_rating
              temp_rating = @most_similar_ratings[j]
              temp_user = @most_similar_users[j]

              @most_similar_ratings[j] = new_rating
              @most_similar_users[j] = k

              new_rating = temp_rating
              k = temp_user
            end
          end

          j += 1
        end
      end

      i += 1
    end

    puts "The top 10 most similar users to user #{u} are"

    i = 0
    while i <= 9
      puts @most_similar_users[i]
      i += 1
    end

    puts ""

    puts "The bottom 10 most similar user to user #{u} are"

    i = @most_similar_users.length-12
    while i <= @most_similar_users.length-1
      puts @most_similar_users[i]
      i += 1
    end

  end
end

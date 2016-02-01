class MovieTest

	def initialize()

		require_relative 'MovieData'

		@m = MovieData.new("ml-100k", "u1");

		stddev = stddev()

		rmse = rms()

		puts "Average Prediction Error: #{@mean}. Standard Deviation: #{stddev}. Root Mean Square Error: #{rmse}."

		return to_a()

	end


	def mean()

		@datalist = []

		i = 0

		prediction_error = 0

		while i < @m.get_training_set().length

			# gets the predicted rating for a specific movie
			predicted = @m.predict(@m.get_training_set()[i], @m.get_training_set()[i+1]).to_i

			# gets the rating for that specific movie
			rating = @m.rating(@m.get_training_set()[i], @m.get_training_set()[i+1])

			# calculates the prediction error
			prediction_error = prediction_error + predicted + rating

			# puts the user, movie, rating, and predicted rating into an array
			@datalist.push(@m.get_training_set()[i], @m.get_training_set()[i+1], rating, predicted)

			i += 4

		end

		# calculates the avg_prediction_error and returns it
		avg_prediction_error = prediction_error / (@m.get_training_set().length / 4)

		return avg_prediction_error

	end


	def mse()

		i = 2
		@mse = 0

		# loops through the data and finds the difference between the rating and the predicted rating
		# it will then square the difference
		while i < @m.get_training_set().length

			@mse += ((@m.get_training_set()[i].to_i - @m.get_training_set()[i+1].to_i)**2)

			i += 4

		end

		# This then calculates the final mse and returns it
		@mse = @mse / (@m.get_training_set().length / 4)

		return @mse

	end


	def variance()

		# calls mean() and gets the average prediction error
		@mean = mean()

		i = 2
		@variance = 0

		# gets the difference from the rating and the average error for predicted ratings
		# it will then square the difference
		while i < @m.get_training_set().length

			@variance += ((@m.get_training_set()[i].to_i - @mean)**2)

			i += 4
		end

		# calculates the variance and returns it
		@variance = @variance / (@m.get_training_set().length / 4)

		return @variance

	end


	def stddev()

		standard_deviation = Math.sqrt(variance())

		return standard_deviation

	end


	def rms()

		root_mean_square_error = Math.sqrt(mse())

		return root_mean_square_error

	end


	def to_a()

		return @datalist

	end
end

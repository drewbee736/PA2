class MovieTest

	def initialize()

		@datalist = []
		
		require 'MovieData'	
	
		@m = MovieData.new("ml-100k", "u1")

		mean = mean()

		stddev = stddev()

		rmse = rms()

		puts "Average Prediction Error: #{mean}. Standard Deviation: #{stddev}. Root Mean Square Error: #{rmse}."

		return to_a()

	end

	
	def mean()

		i = 0

		prediction_error = 0		

		while i < @m.traing_set.length

			predicted = @m.predict(@m.training_set[i], @m.training_set[i+1])
		
			rating = @m.rating(@m.training_set[i], @m.training_set [i+1])
		
			prediction_error += predicted + rating

			@datalist.push(@m.training_set[i], @m.training_set[i+1], rating, predicted)		
	
			i += 4
	
		end

		@avg_prediction_error = prediction_error / (@m.training_set.length / 4)
	
		return avg_prediction_error

	end


	def mse()

		i = 2
		@mse = 0
		
		while i < @m.training_set.length
		
			@mse += ((@m.training_set[i] - @m.training_set[i+1])**2)	

			i += 4

		end

		@mse = @mse / (@m.training_set.length / 4)

		return @mse
	
	end


	def variance()

		mean = mean()

		i = 2
		@variance = 0

		while i < @m.training_set.length
	
			@variance += ((@m.training_set[i] - mean)**2)

			i += 4
		end

		@variance = @variance / (@m.training_set.length / 4)

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
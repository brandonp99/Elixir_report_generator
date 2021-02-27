defmodule ReportGenerator.Processor do

	import ReportGenerator.Tools

	@moduledoc """

	reads the provided CSV file and uses the resulting data to generate a report with the following information:
		- Total revenue from each order
		- Total revenue made each year
		- The best selling item (for both years)
		- The best performing representative
	"""

	@doc """
	Generates a report by constructing a list from the csv data and passes it to the rest of this modules functions using the return to print the information
	"""
	def start do
		list = Tuple.to_list(read_file('priv/data/sales_sample.csv'))
		data = List.last(list)

		revenue = create_report_revenue(data)
		IO.write("Data Report: \n")
		IO.write("Total Revenue per Order: \n")
		IO.write("#{
			for [cost, year] <- Enum.fetch!(revenue, 0) do
				"€#{Float.to_string(cost)} - #{year} \n"
			end
		}")
		IO.write("Total Revenue Per Year: \n#{
			for [year, cost] <- Enum.fetch!(revenue, 1) do
				"€#{Float.to_string(cost)} - #{year} \n"
			end
		}")
		IO.write("Best Selling Item Per Year: \n#{
			for item <- create_report_best_selling(data) do
				"#{Atom.to_string(List.first(item[:item]))} - #{item[:year]} \n"
			end
		}")
		IO.write("Best Performing Representative: \n#{
			Atom.to_string(List.first(Keyword.keys(create_report_best_performing_rep(data))))
		} - €#{Float.to_string(List.first(Keyword.values(create_report_best_performing_rep(data))))}\n")
	end

	@doc """
	Returns two lists, one containing the individual total revenue for each order and that order's date and the other for the total revenue added per year along with the year
	"""
	def create_report_revenue(data) do

		dates = get_dates(data)

		values = for {row, counter} <- Enum.with_index(data) do

			cost = String.to_float(String.replace(Enum.fetch!(row, 5), " ", ""))
			units = String.to_integer(Enum.fetch!(row, 4))

			[vals: Float.round(cost * units, 2), yrs: Enum.fetch!(dates, counter)]
		end

		years = for date <- List.flatten(dates) do
			date.year
		end
		years = Enum.uniq(years)

		values_per_year = for year <- years do
			Enum.filter(values, fn row -> row[:yrs].year == year end)
		end

		costs = for year <- values_per_year do
			for value <- year do
				value[:vals]
			end
		end

		costs_per_year = for {year_cost, counter} <- Enum.with_index(costs) do
			[Enum.fetch!(years, counter), Float.round(Enum.sum(year_cost), 2)]
		end

		dated_values = for value <- values do
			[value[:vals], Date.to_string(value[:yrs])]
		end

		[dated_values, costs_per_year]
	end

	@doc """
	Returns a Keyword List with the best selling item for each year. This is calculated bast on the amount of units sold
	"""
	def create_report_best_selling(data) do
		items = for row <- data do
			[{String.to_atom(Enum.fetch!(row, 3)), Enum.fetch!(row, 4)}]
		end

		dates = get_dates(data)

		items_with_dates = for {item, counter} <- Enum.with_index(items) do
			[item, yrs: Enum.fetch!(dates, counter).year]
		end

		years = Enum.uniq(Keyword.get_values(List.flatten(items_with_dates), :yrs))

		items_per_year = for year <- years do
			Enum.filter(items_with_dates, fn row -> row[:yrs] == year end)
		end

		unique_items_per_year = for year <- items_per_year do
			keys = Enum.uniq(Keyword.keys(List.flatten(year)))

			List.delete(keys, :yrs)
		end

		item_sales = for {_, count} <- Enum.with_index(years) do
			for key <- Enum.fetch!(unique_items_per_year, count) do
				item_values = Keyword.get_values(List.flatten(Enum.fetch!(items_per_year, count)), key)

				new_item_values = for value <- item_values do
					String.to_integer(value)
				end

				[{key, Enum.sum(new_item_values)}]
			end
		end

		results = for items <- item_sales do
			Enum.max_by(items, fn x -> Keyword.values(x) end)
		end

		for {result, count} <- Enum.with_index(results) do
			[item: Keyword.keys(result), year: Enum.fetch!(years, count)]
		end

	end

	@doc """
	Returns a Keyword List with one entry containing the representative that performed the best(based on overall sales) throughout the data provided and the revenue he/she has made.
	"""
	def create_report_best_performing_rep(data) do
		rep_sales = for row <- data do
			[{String.to_atom(Enum.fetch!(row, 2)), Float.round(String.to_integer(Enum.fetch!(row, 4)) * String.to_float(String.replace(Enum.fetch!(row, 5), " ", "")))}]
		end

		keys = Enum.uniq(Keyword.keys(List.flatten(rep_sales)))

		rep_overall_sales = for key <- keys do
			rep_values = Keyword.get_values(List.flatten(rep_sales), key)

			[{key, Enum.sum(rep_values)}]
		end

		Enum.max_by(rep_overall_sales, fn x -> Keyword.values(x) end)
	end

end

# ReportGenerator - Exercise

This idea behind this exercise is to have a gentle introduction to Elixir. Elixir syntax is quite simple but since its a functional language it needs a slight different thought process.

The exercise entails processing a simple csv file to create a number of "reports". The csv is a sales sheet each record is considered to be an order sold to a respective representative. The file is found in priv/data/sales_sample.csv

### Task List

**TODO: Parse CSV file **(libraries available to read csv)

**TODO: Process the CSV records to be able to output the following information**

- Total revenue from each order
- Total revenue made each year
- The best selling item (for both years)
- The best performing representative 

## Installation &  Usage

To install elixir follow instruction from the official site of elixir https://elixir-lang.org/install.html . 

Once installed there are a number of commands you can use to interact with the application. The folder provided is a simple elixir project generated using mix new (with some minor updates). To interact with the application change directory to the folder and use one of the following commands

- List all available commands - mix help

- Get dependencies - mix deps.get

- Compile deps - mix deps.compile

- Compile code - mix compile

- The application is not a service so to interact with the application it is ideal to run the application in an interactive shell - iex -S mix
  

  Once this is started you are in the erlang terminal. To call the code I updated call the following function:
  |> ReportGenerator.generate_report
  

  HINT: You can also recompile in the interactive shell by typing |> recompile

## Folder Structure

|> lib <--- Contains the code for the application
|> lib/report_generator.ex <-- The main module I created to easily interact with the application
|> lib/report_generator/processor.ex <-- Module where I started to create functions for this exercise

|> priv/data/sales_sample.csv <-- The CSV File
|> mix.exs <-- Elixir used mix.exs to define the main features of the application and dependencies required (similar to package.json)

## Helpful Links

https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html

https://hexdocs.pm/elixir/master/Enum.html

https://hexdocs.pm/elixir/master/IO.html#content
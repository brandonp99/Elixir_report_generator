defmodule ReportGenerator.Tools do

  @moduledoc """
  A module to house the additional functions for creating a report
  """

  @doc """
  reads the CSV file provided and returns a list of the containing data
  """
  def read_file(csv_file) do
    stream = File.stream!(csv_file)
    csv = CSV.decode!(stream)
    Enum.split(csv, 1)
   end

   @doc """
   creates a list of dates from the string data provided
   """
   def get_dates(data) do
    for row <- data do
      #fetch date string from data
      date_deconstructed = String.split(Enum.fetch!(row, 0), "/")

      #rearrange order from m/d/y to d-m-y while adding 0 if day or month is single digit
      date_deconstructed = "20#{Enum.fetch!(date_deconstructed, 2)}-#{if String.to_integer(Enum.fetch!(date_deconstructed, 0)) < 10 do
        "0#{Enum.fetch!(date_deconstructed, 0)}"
      else
        Enum.fetch!(date_deconstructed, 0)
      end}-#{
      if String.to_integer(Enum.fetch!(date_deconstructed, 1)) < 10 do
        "0#{Enum.fetch!(date_deconstructed, 1)}"
      else
        Enum.fetch!(date_deconstructed, 1)
      end}"

      #convert date string to Date
      Date.from_iso8601!(date_deconstructed)
    end
   end

end

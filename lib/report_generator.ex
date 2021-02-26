defmodule ReportGenerator do
  @moduledoc """
  Documentation for `ReportGenerator`.
  """

  defp current_date do
    DateTime.utc_now 
     |> DateTime.to_date 
     |> to_string
  end

  @doc """
  Start running generate report.
  ## Examples
      iex> ReportGenerator.generate_report
  """
  def generate_report do
    current_date = current_date()
    IO.puts("---- GENERATING REPORTS $ #{current_date} $")
    ReportGenerator.Processor.start()
  end
end

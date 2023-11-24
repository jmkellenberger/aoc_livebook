template = File.read!("aoc_template.livemd")

%{day: current_day, month: current_month, year: current_year} = Date.utc_today()

is_december? = current_month == 12

args =
  System.argv()
  |> Enum.map(&Integer.parse/1)
  |> Enum.map(fn
    {int, _} ->
      int

    :error ->
      :error
  end)

valid_day? = fn d -> d in 1..25 end
valid_year? = fn y -> y in 2016..current_year end

validate_input = fn d, y ->
  cond do
    not valid_day?.(d) ->
      {:error, "Day must be between 1 and 25."}

    not valid_year?.(y) ->
      {:error, "Year must be a valid AoC year (2016 - #{current_year})."}

    y == current_year and not is_december? ->
      {:error,
       "Advent of Code does not start until December 1st. Try a previous year in the meantime."}

    true ->
      :ok
  end
end

generate_template = fn day, year ->
  template_content =
    template
    |> String.replace("{{YEAR}}", Integer.to_string(year))
    |> String.replace("{{DAY}}", Integer.to_string(day))

  output_dir = Integer.to_string(year)
  output_file = "aoc_#{String.pad_leading(Integer.to_string(day), 2, "0")}.livemd"
  output_path = Path.join(output_dir, output_file)

  # Check if the file already exists
  if File.exists?(output_path) do
    IO.puts(
      "Livebook template for Advent of Code #{year}, Day #{day} already exists at #{output_path}"
    )
  else
    File.mkdir_p!(output_dir)

    File.write!(output_path, template_content)

    IO.puts(
      "Generated Livebook template for Advent of Code #{year}, Day #{day} at #{output_path}"
    )
  end
end

try_generate_template = fn day, year ->
  case validate_input.(day, year) do
    :ok -> generate_template.(day, year)
    {:error, msg} -> IO.puts(msg)
  end
end

case args do
  [] ->
    try_generate_template.(current_day, current_year)

  [day] ->
    try_generate_template.(day, current_year)

  [day, year | _] ->
    try_generate_template.(day, year)
end

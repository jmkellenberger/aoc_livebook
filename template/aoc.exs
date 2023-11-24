%{day: current_day, month: current_month, year: current_year} = Date.utc_today()

validate_input = fn d, y ->
  cond do
    d not in 1..25 ->
      {:error, "Day must be between 1 and 25."}

    y not in 2016..current_year ->
      {:error, "Year must be a valid AoC year (2016 - #{current_year})."}

    y == current_year and not current_month == 12 ->
      {:error,
       "Advent of Code does not start until December 1st. Try a previous year in the meantime."}

    true ->
      :ok
  end
end

generate_template = fn day, year ->
  case validate_input.(day, year) do
    {:error, msg} ->
      raise msg

    :ok ->
      output_dir = to_string(year)
      output_file = "aoc_#{String.pad_leading(to_string(day), 2, "0")}.livemd"
      output_path = Path.join(output_dir, output_file)

      if File.exists?(output_path) do
        raise "Livebook template for Advent of Code #{year}, Day #{day} already exists at #{output_path}"
      else
        template_content =
          "template/aoc_template.livemd"
          |> File.read!()
          |> String.replace("{{YEAR}}", to_string(year))
          |> String.replace("{{DAY}}", to_string(day))

        File.mkdir_p!(output_dir)

        File.write!(output_path, template_content)

        IO.puts(
          "Generated Livebook template for Advent of Code #{year}, Day #{day} at #{output_path}"
        )
      end
  end
end

System.argv()
|> Enum.map(&Integer.parse/1)
|> Enum.map(fn
  {int, _} ->
    int

  :error ->
    :error
end)
|> case do
  [] ->
    generate_template.(current_day, current_year)

  [day] ->
    generate_template.(day, current_year)

  [day, year | _] ->
    generate_template.(day, year)
end

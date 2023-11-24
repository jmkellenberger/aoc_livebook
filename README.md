# Advent of Code Livebook Generator

A simple script to generate and launch Livebooks for Advent of Code puzzles.

## Requirements
- Your Advent of Code session token set as a Livebook secret: `LB_AOC_TOKEN`.

- Make sure Livebook is installed with `mix escript.install hex livebook`.

## Getting Started
1. Clone the repository and `cd aoc_livebook`

3. Run `bin/gen day year` to generate and launch a Livebook for a specific Advent of Code puzzle.

   Example:
   ```
   bin/gen 1 2016

   bin/gen 1 # Day 1 of the Current Year

   bin/gen 1 # Today's puzzle, if any.
   ```

## Notes
- The generated Livebooks are located at `aoc_livebook/$year/aoc_$day.livemd`.

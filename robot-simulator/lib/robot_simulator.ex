defmodule RobotSimulator do
  defstruct direction: :nort, position: {0, 0}

  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer, integer}

  @type robot() :: %__MODULE__{
          direction: direction,
          position: position
        }

  @directions [:north, :east, :south, :west]

  defguardp is_direction(direction) when direction in @directions

  defguardp is_position(position)
            when tuple_size(position) == 2 and
                   is_number(elem(position, 0)) and
                   is_number(elem(position, 1))

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, position) when is_direction(direction) and is_position(position) do
    %__MODULE__{direction: direction, position: position}
  end

  def create(direction, _) when not is_direction(direction) do
    {:error, "invalid direction"}
  end

  def create(_, _) do
    {:error, "invalid position"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot | {:error, String.t()}
  def simulate(%__MODULE__{} = robot, <<>> = _instructions) do
    robot
  end

  def simulate(%__MODULE__{direction: direction} = robot, "R" <> instructions) do
    simulate(%{robot | direction: turn(direction, "R")}, instructions)
  end

  def simulate(%__MODULE__{direction: direction} = robot, "L" <> instructions) do
    simulate(%{robot | direction: turn(direction, "L")}, instructions)
  end

  def simulate(%__MODULE__{direction: direction, position: position} = robot, "A" <> instructions) do
    simulate(%{robot | position: advance(position, direction)}, instructions)
  end

  def simulate(%__MODULE__{}, _) do
    {:error, "invalid instruction"}
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction
  def direction(%__MODULE__{direction: direction}) do
    direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position
  def position(%__MODULE__{position: position}) do
    position
  end

  # Privates

  defp turn(direction, "R") do
    turn_direction(@directions, direction)
  end

  defp turn(direction, "L") do
    @directions
    |> Enum.reverse()
    |> turn_direction(direction)
  end

  defp turn_direction(directions, direction) do
    directions
    |> Stream.cycle()
    |> Stream.drop_while(&(direction != &1))
    |> Enum.at(1)
  end

  defp advance({x, y}, :north) do
    {x, y + 1}
  end

  defp advance({x, y}, :east) do
    {x + 1, y}
  end

  defp advance({x, y}, :south) do
    {x, y - 1}
  end

  defp advance({x, y}, :west) do
    {x - 1, y}
  end
end

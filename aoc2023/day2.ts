type Game = {
  id: number,
  rounds: Round[]
}

type Round = {
  red: number, blue: number, green: number
}

export function parse(line:string):Game {
  const [game_str, rounds_str] = line.split(":", 2);
  const [_, game_idx] = game_str.split(" ", 2);
  const rounds = rounds_str.split(";").map((round_str) => {
    const count_colors = round_str.split(',').map((l) => l.trim());
    const round = { red: 0, blue: 0, green: 0 };
    count_colors.forEach((count_color) => {
      const [count, color] = count_color.split(' ');
      // console.log(`'${count_color}'`, count, color);
      if (color == "red" || color == "blue" || color == "green") {
        round[color] = parseInt(count);
      }
    });
    return round;
  });
  return {
    id: parseInt(game_idx),
    rounds:  rounds
  };
}

export function part_1(lines: string[]): number {
  const max =  { red: 12, green: 13, blue: 14 };
  let sum = 0;
  lines.forEach((line) => {
    const game = parse(line);
    const valid = game.rounds.filter((round) => {
      return round.red <= max.red && round.green <= max.green && round.blue <= max.blue;
    });
    if (valid.length == game.rounds.length) {
      sum += game.id;
    }
  });
  return sum;
}

type ColorAccessor = (r:Round) => number;

export function part_2(lines:string[]):number {
    let sum = 0;
    lines.forEach((line) => {
      const game = parse(line);
      const max = (rounds:Round[], get_color:ColorAccessor) => {
        let m = 0;
        rounds.forEach((r) => {
          const n = get_color(r);
          if (n > m) {
            m = n;
          }
        });
        return m;
      };
      const max_red = max(game.rounds, (r) => r.red); 
      const max_blue = max(game.rounds, (r) => r.blue); 
      const max_green = max(game.rounds, (r) => r.green);
      sum += max_red * max_blue * max_green;
    });
    return sum;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day2.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1(lines));
  console.log("part 2: ", part_2(lines));
}

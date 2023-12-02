export function part_1(lines: string[]): number {
  let sum = 0;
  lines.forEach((line) => {
    const digits = line.replaceAll(/[^0-9]/g, "").split('');
    const n = digits[0] + digits[digits.length-1];
    sum += parseInt(n);
  });
  return sum;
}

export function part_2(lines:string[]):number {
    const digits = [
        "zero",
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine"
    ];
    let sum = 0;
    lines.forEach((line) => {
        let first_digit_index = line.length;
        let first_digit = 0;
        let last_digit_index = 0;
        let last_digit = 0;
        digits.forEach((digit, i) => {
            const first_as_word = line.indexOf(digit);
            if (first_as_word >= 0 && first_as_word <= first_digit_index) {
                first_digit_index = first_as_word;
                first_digit = i;
            }
            const first_as_digit = line.indexOf(i.toString());
            if (first_as_digit >= 0 && first_as_digit <= first_digit_index) {
                first_digit_index = first_as_digit;
                first_digit = i;
            }
            const last_as_word = line.lastIndexOf(digit);
            if (last_as_word >= 0 && last_as_word >= last_digit_index) {
                last_digit_index = last_as_word;
                last_digit = i;
            }
            const last_as_digit = line.lastIndexOf(i.toString());
            if (last_as_digit >= 0 && last_as_digit >= last_digit_index) {
                last_digit_index = last_as_digit;
                last_digit = i;
            }
        });
        const n = (first_digit * 10) + last_digit;
        sum += n;
    });
    return sum;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day1.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1(lines));
  console.log("part 2: ", part_2(lines));
}

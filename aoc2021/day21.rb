class DeterministicDice
    attr_reader :num_rolls
    def initialize
        @num_rolls = 0
        @next_roll = 1
    end

    def roll
        @num_rolls += 1
        r = @next_roll
        @next_roll = @next_roll == 100 ? 1 : @next_roll+1
        r
    end

    def roll_3
       self.roll + self.roll + self.roll
    end
end

class Game 
    attr_reader :positions, :scores
    def initialize(dice, p1, p2)
        @dice = dice
        @positions = [p1, p2]
        @scores = [0, 0]
        @whos_turn = 0
    end

    def turn
        spaces = @dice.roll_3
        next_position = 1 + ((@positions[@whos_turn] + spaces - 1) % 10)
        @positions[@whos_turn] = next_position
        @scores[@whos_turn] += next_position
        if @scores[@whos_turn] >= 1000
            return @scores[1-@whos_turn]
        end
        @whos_turn = 1-@whos_turn
        nil
    end
end

def part_a()
    dice = DeterministicDice.new
    game = Game.new(dice, 3, 4)
    while true
        loser_score = game.turn
        if !loser_score.nil?
            return loser_score * dice.num_rolls
        end
    end
end

TURN_OUTCOMES = Array.new(10, 0)
[1,2,3].each do |a|
    [1,2,3].each do |b|
        [1,2,3].each do |c|
            TURN_OUTCOMES[a+b+c] += 1
        end
    end
end

P1 = 0
P2 = 1
POS = 0
SCORE = 2
TURN = 4
GAME_OVER = -1

def get_wins(state, wins)
    if wins.key? state
        return wins[state]
    end
    player = state[TURN]
    raise "???" if player == GAME_OVER
    (3..9).each do |move|
        next_state = state.clone
        next_state[player + POS] = (state[player + POS] + move) % 10
        next_score = next_state[player + POS] + 1 + state[player + SCORE]
        next_turn = 1 - player
        if next_score >= 21
            next_score = 21
            next_turn = GAME_OVER
        end
        next_state[TURN] = next_turn
        next_state[player + SCORE] = next_score
        
        if next_turn == GAME_OVER
            wins[state][player] += TURN_OUTCOMES[move]
        else
            downstream_wins = get_wins(next_state, wins)
            wins[state][player] += downstream_wins[player] * TURN_OUTCOMES[move]
            wins[state][1-player] += downstream_wins[1-player] * TURN_OUTCOMES[move]
        end
    end
    wins[state]
end

def part_b(initial)
    wins = Hash.new { |h,k| h[k] = [0, 0] }
    get_wins(initial, wins).minmax
end

if __FILE__ == $0
    puts part_b([2, 3, 0, 0, P1]).inspect
    #puts part_b([3, 7, 0, 0, P1]).inspect
end
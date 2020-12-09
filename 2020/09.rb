# nnoremap <silent> <CR> :!ruby %<CR>
input = File.readlines("09.input.txt", chomp: true).map(&:to_i)

# === part 1

def solve_part1(input)
  a, b = 0, 24

  loop do
    if input[a..b].combination(2).map(&:sum).include?(input[b + 1])
      a += 1
      b += 1
    else
      break
    end
  end

  input[b + 1]
end

# solve_part1(input)
# => 1124361034

# === part 2

def solve_part2(input, wanted_sum)
  a, b = 0, 1
  range = nil

  loop do
    range = input[a..b]
    range_sum = range.sum

    if range_sum == wanted_sum
      break
    elsif range_sum < wanted_sum
      b += 1
    else
      a += 1
    end
  end

  range.minmax.sum
end

solve_part2(input, 1124361034)
# => 129444555

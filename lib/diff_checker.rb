# frozen_string_literal: true
class DiffChecker
  def initialize(dataset1, dataset2)
    @dataset1 = dataset1
    @dataset2 = dataset2
  end

  def diff
    diffs = HashDiff.diff(@dataset1, @dataset2)

    # [['+', '[0]', {...}], ['+', '[1]', {...}], ...]
    diffs.map! do |diff|
      {
        # e.g. '[0]' => 1, '[30]' => 31
        position: diff[1][1..-2].to_i + 1,
        type: diff[0],
        value: diff[2]
      }
    end

    diffs.sort_by { |diff| [diff[:position], diff[:type]] }
  end
end

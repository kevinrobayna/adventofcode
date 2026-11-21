# frozen_string_literal: true

require_relative '../../lib/aoc'

# The 24 proper rotations of 3D space as lambdas on [x, y, z].
ROTATIONS = [0, 1, 2].permutation.flat_map do |perm|
  [1, -1].product([1, -1], [1, -1]).filter_map do |signs|
    matrix = Array.new(3) { |i| Array.new(3) { |j| perm[i] == j ? signs[i] : 0 } }
    det = (matrix[0][0] * ((matrix[1][1] * matrix[2][2]) - (matrix[1][2] * matrix[2][1]))) -
          (matrix[0][1] * ((matrix[1][0] * matrix[2][2]) - (matrix[1][2] * matrix[2][0]))) +
          (matrix[0][2] * ((matrix[1][0] * matrix[2][1]) - (matrix[1][1] * matrix[2][0])))
    [perm, signs] if det == 1
  end
end.freeze

def rotate(point, (perm, signs))
  [point[perm[0]] * signs[0], point[perm[1]] * signs[1], point[perm[2]] * signs[2]]
end

def parse(input)
  input.split("\n\n").map do |block|
    block.split("\n").drop(1).map { |line| line.split(',').map(&:to_i) }
  end
end

# Tries to place `scan` against the known beacons; returns [rotated beacons, scanner position] or nil.
def align(known, scan)
  ROTATIONS.each do |rotation|
    rotated = scan.map { |p| rotate(p, rotation) }
    offsets = Hash.new(0)
    known.each do |k|
      rotated.each do |r|
        offset = [k[0] - r[0], k[1] - r[1], k[2] - r[2]]
        next unless (offsets[offset] += 1) >= 12

        return [rotated.map { |p| [p[0] + offset[0], p[1] + offset[1], p[2] + offset[2]] }, offset]
      end
    end
  end
  nil
end

# Squared pairwise distances are rotation-invariant: used to skip scanner pairs that cannot overlap.
def fingerprint(beacons)
  beacons.combination(2).to_set { |a, b| a.zip(b).sum { |x, y| (x - y)**2 } }
end

def assemble(input)
  scans = parse(input)
  prints = scans.map { |s| fingerprint(s) }
  placed = { 0 => scans[0] }
  positions = { 0 => [0, 0, 0] }
  frontier = [0]
  until frontier.empty?
    base = frontier.shift
    scans.each_index do |i|
      next if placed.key?(i) || (prints[base] & prints[i]).size < 66

      result = align(placed[base], scans[i])
      next unless result

      placed[i], positions[i] = result
      frontier << i
    end
  end
  raise 'Could not place all scanners' unless placed.size == scans.size

  [placed.values.flatten(1).uniq, positions.values]
end

def solve(input)
  assemble(input).first.size
end

def solve2(input)
  assemble(input).last.combination(2).map { |a, b| a.zip(b).sum { |x, y| (x - y).abs } }.max
end

class AoCTest < Minitest::Test # rubocop:disable Metrics/ClassLength
  EXAMPLE = <<~INPUT
    --- scanner 0 ---
    404,-588,-901
    528,-643,409
    -838,591,734
    390,-675,-793
    -537,-823,-458
    -485,-357,347
    -345,-311,381
    -661,-816,-575
    -876,649,763
    -618,-824,-621
    553,345,-567
    474,580,667
    -447,-329,318
    -584,868,-557
    544,-627,-890
    564,392,-477
    455,729,728
    -892,524,684
    -689,845,-530
    423,-701,434
    7,-33,-71
    630,319,-379
    443,580,662
    -789,900,-551
    459,-707,401

    --- scanner 1 ---
    686,422,578
    605,423,415
    515,917,-361
    -336,658,858
    95,138,22
    -476,619,847
    -340,-569,-846
    567,-361,727
    -460,603,-452
    669,-402,600
    729,430,532
    -500,-761,534
    -322,571,750
    -466,-666,-811
    -429,-592,574
    -355,545,-477
    703,-491,-529
    -328,-685,520
    413,935,-424
    -391,539,-444
    586,-435,557
    -364,-763,-893
    807,-499,-711
    755,-354,-619
    553,889,-390

    --- scanner 2 ---
    649,640,665
    682,-795,504
    -784,533,-524
    -644,584,-595
    -588,-843,648
    -30,6,44
    -674,560,763
    500,723,-460
    609,671,-379
    -555,-800,653
    -675,-892,-343
    697,-426,-610
    578,704,681
    493,664,-388
    -671,-858,530
    -667,343,800
    571,-461,-707
    -138,-166,112
    -889,563,-600
    646,-828,498
    640,759,510
    -630,509,768
    -681,-892,-333
    673,-379,-804
    -742,-814,-386
    577,-820,562

    --- scanner 3 ---
    -589,542,597
    605,-692,669
    -500,565,-823
    -660,373,557
    -458,-679,-417
    -488,449,543
    -626,468,-788
    338,-750,-386
    528,-832,-391
    562,-778,733
    -938,-730,414
    543,643,-506
    -524,371,-870
    407,773,750
    -104,29,83
    378,-903,-323
    -778,-728,485
    426,699,580
    -438,-605,-362
    -469,-447,-387
    509,732,623
    647,635,-688
    -868,-804,481
    614,-800,639
    595,780,-596

    --- scanner 4 ---
    727,592,562
    -293,-554,779
    441,611,-461
    -714,465,-776
    -743,427,-804
    -660,-479,-426
    832,-632,460
    927,-485,-438
    408,393,-506
    466,436,-512
    110,16,151
    -258,-428,682
    -393,719,612
    -211,-452,876
    808,-476,-593
    -575,615,604
    -485,667,467
    -680,325,-822
    -627,-443,-432
    872,-547,-609
    833,512,582
    807,604,487
    839,-516,451
    891,-625,532
    -652,-548,-490
    30,-46,-14

  INPUT

  def test_rotations
    assert_equal 24, ROTATIONS.size
  end

  def test_solve_example
    assert_equal 79, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 405, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3621, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 12_306, solve2(read_file('input.txt'))
  end
end

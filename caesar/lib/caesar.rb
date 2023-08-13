# frozen_string_literal: true

def do_shift(position, shift)
  (position + shift) % 26
end

def caesar_cipher(cleartext, shift)
  shifted = cleartext.chars.map do |c|
    if c.between?('a', 'z')
      (do_shift(c.ord - 'a'.ord, shift) + 'a'.ord).chr
    elsif c.between?('A', 'Z')
      (do_shift(c.ord - 'A'.ord, shift) + 'A'.ord).chr
    else
      c
    end
  end
  shifted.join
end

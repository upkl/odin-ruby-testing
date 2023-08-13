def do_shift position, shift
  (position + shift) % 26
end

def caesar_cipher cleartext, shift
  shifted = cleartext.split("").map do |c|
    if 'a' <= c and c <= 'z'
      (do_shift(c.ord - 'a'.ord, shift) + 'a'.ord).chr
    elsif 'A' <= c and c <= 'Z'
      (do_shift(c.ord - 'A'.ord, shift) + 'A'.ord).chr
    else
      c
    end
  end
  shifted.join("")
end

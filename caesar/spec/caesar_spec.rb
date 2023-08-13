# frozen_string_literal: true

require './lib/caesar'

describe 'Caesar cipher' do
  it 'handles empty input' do
    expect(caesar_cipher('', 9)).to eql('')
  end

  it 'handles uppercase letters' do
    expect(caesar_cipher('A', 4)).to eql('E')
  end

  it 'handles lowercase letters' do
    expect(caesar_cipher('g', 8)).to eql('o')
  end

  it 'ignores whitespace and punctuation' do
    teststring = "!.,;:-_+() \n\t"
    expect(caesar_cipher(teststring, 9)).to eql(teststring)
  end

  it 'handles overflows' do
    expect(caesar_cipher('T', 20)).to eql('N')
  end

  it 'handles complex input' do
    plaintext = 'If he had anything confidential to say, he wrote it in cipher, that is, by so changing the order of ' \
                'the letters of the alphabet, that not a word could be made out.'
    ciphertext = 'Pm ol ohk hufaopun jvumpkluaphs av zhf, ol dyval pa pu jpwoly, aoha pz, if zv johunpun aol vykly ' \
                 'vm aol slaalyz vm aol hswohila, aoha uva h dvyk jvbsk il thkl vba.'
    expect(caesar_cipher(plaintext, 7)).to eql(ciphertext)
  end
end

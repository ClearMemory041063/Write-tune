#Steganography2a.rb
# 18 Oct 2017

#helper function
define :midi2note do |n2|
  nn1=note(n2)
  if nn1==nil
    return nn1
  else
    nn1= note_info(nn1)
    nnn1=nn1.to_s.split(":")
    mmm1= nnn1[3].chop
    return mmm1
  end
end # midi2note
define :listnotes do |n1|
  i1=0
  while i1<n1.length
    puts midi2note(n1[i1])
    i1+=1
  end
end
#define intervals
octave=12
#Define tempo and note lengths
#####
tempo=1.0 ### try changing tempo 0.75
#define note timings
whole=1.0
half=whole/2.0
#dothalf=half*1.5
quart=half/2.0
#dotquart=quart*1.5
eighth=quart/2.0
#doteighth=eighth*1.5
sixteenth=eighth/2
#########
### try different keys
key= note(:c4)
puts midi2note(key)
puts " "
### try minor
puts scale_names
mode= :major
#:dorian
#:zhi
#:yu
#:major
# setup chord progression in a and b
a=chord_invert(chord_degree :i, key, mode,3),0
listnotes (a)

b=chord_invert(chord_degree :ii, key, mode,3),0
listnotes(b)
### create list of possible melody notes that will blend
# with the chord progression avoid playing notes that differ by
# a halftone in pitch by inserting a rest in the melody
c1=scale(key,mode)
i=0
c=[[],[],[],[],[],[]]
while i<(c1.length-1)
  j=0
  while j<6
    c[j]=c[j].push c1[i]
    j+=1
  end
  i+=1
end

puts "c",midi2note(c[0][6])
c[0][6]=nil
puts c[0]
puts "e",midi2note(c[1][3])
c[1][3]=nil
puts c[1]
puts "g",c[2]
puts "d",c[3]
puts "f",midi2note(c[4][2])
c[4][2]=nil
puts c[4]
puts "A",c[5]
# index the exclusion arrays to the chord progression
d=[0,1,2,0,1,2,3,4,5,3,4,5]

#the plaintext to hide in the melody
plaintext="Lord Qwerty asked us to play"
plaintext+="Rhapsody in Blue"
plaintext+="0123456789"

ms0="-1,staff,0,voice,0;"
ms1="-1,staff,1,voice,0;"
define :staff0 do |p,d|
  if (p==nil)
    p=-1
  else
    p-=12
  end
  ms0+="1,"+(2/d).to_s+","+p.to_s+";"
end

define :staff1 do |p,d|
  if (p==nil)
    p=-1
  else
    p-=12
  end
  ms1+="1,"+(2/d).to_s+","+p.to_s+";"
  
end


stp=0
stplimit=4
live_loop :LL1 do
  use_synth :fm
  with_fx :level, amp: 0.2 do
    jj=0
    while jj<2*a.length
      puts j,midi2note(a[jj])
      play a[jj]
      sleep quart*tempo
      staff1(a[jj],quart)
      jj+=1
    end
    jj=0
    while jj<2*b.length
      puts midi2note(b[jj])
      play b[jj]
      sleep quart*tempo
      staff1(b[jj],quart)
      jj+=1
    end
    if stp>stplimit
      puts ms1+":/n"
      stop
    end
  end
end #LL1
live_loop :LL2 do
  sync :LL1
  use_synth :fm
  with_fx :level, amp: 0.2 do
    i=0
    j=0
    while i<plaintext.length
      n=plaintext[i].ord-32
      oct=(n/64)*octave+octave
      nn=n%8
      nnn=(n/8)%8
      nn=c[d[j]][nn]
      j+=1
      if j>11 then j=0 end
      nnn=c[d[j]][nnn]
      j+=1
      if j>11 then j=0 end
      if nn!=nil then nn+=oct end
      if nnn!=nil then nnn+=oct end
      puts midi2note(nn)
      play nn
      sleep quart*tempo
      staff0(nn,quart)
      puts midi2note(nnn)
      play nnn
      sleep quart*tempo
      staff0(nnn,quart)
      i+=1
    end
    stp+=1
    if stp>stplimit
      puts ms0+":"
      
      stop
    end
  end
end #LL2



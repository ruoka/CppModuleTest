echo '#c++'
grep -H -E '\s*import\s*([a-z_0-9]+)' *.c++
grep -H -E '\s*import\s*([a-z_0-9]+)' *.c++ | sed -E 's/(^[a-z_0-9]+)\.c\+\+:\s*import\s*([a-z_0-9]+);/\1.o: \2.pcm/'

echo '#c++ partition'
grep -H -E '\s*import\s*:([a-z_0-9]+)' *.c++
grep -H -E '\s*import\s*:([a-z_0-9]+)' *.c++ | sed -E 's/(^[a-z_0-9]+)\.c\+\+:\s*import\s*([a-z_0-9]+);/\1.o: \1-\2.pcm/'

echo '#c++m'
grep -H -E '\s*import\s*([a-z_0-9]+)' *.c++m
grep -H -E '\s*import\s*([a-z_0-9]+)' *.c++m | sed -E 's/(^[a-z_0-9]+)\.c\+\+m:.*import\s*([a-z_0-9]+);/\1.pcm: \2.pcm/'

echo '#c++m partition'
grep -H -E '\s*import\s*:([a-z_0-9]+)' *.c++m
grep -H -E '\s*import\s*:([a-z_0-9]+)' *.c++m | sed -E 's/(^[a-z_0-9]+)\.c\+\+m:.*import\s*:([a-z_0-9]+);/\1.pcm: \1-\2.pcm/'

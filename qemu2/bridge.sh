killall nc || true
nc -l 1233 | nc -l 1234 &
nc -l 1235 | nc -l 1236 &

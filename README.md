# Docker
`docker-machine create --driver virtualbox --virtualbox-cpu-count 8 --virtualbox-memory 4096 noredink`

`eval $(docker-machine env noredink)`

# Script
`docker-compose run --rm dev`

# Tests
`docker-compose run --rm test`

# Console
`docker-compose run --rm dev tux`

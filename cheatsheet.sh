docker build -t nttdata_test_test . --target=test
docker run --rm -it nttdata_test_test

docker build -t nttdata_test_prod . --target=production
docker run --rm -it nttdata_test_prod

docker build -t nttdata_test_dev . --target=development
docker run --rm -it nttdata_test_dev -v ${PWD}:/app

docker tag nttdata_test macabrabits/nttdata_test:1
docker push macabrabits/nttdata_test:1
docker run --rm -it nttdata_test


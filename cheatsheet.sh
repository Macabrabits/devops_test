docker build -t nttdata_test_test . --target=test
docker run --rm -it -v ${PWD}/coverage:/app/coverage nttdata_test_test

docker build -t nttdata_test_dev . --target=development
docker run --rm -it -v ${PWD}:/app nttdata_test_dev

docker build -t nttdata_test_prod . --target=production
docker run --rm -it nttdata_test_prod

docker tag nttdata_test macabrabits/nttdata_test:1
docker push macabrabits/nttdata_test:1
docker run --rm -it nttdata_test

git tag v0.0.1
git tag -d v0.0.1 rm
git push origin --tags
git reset --hard 93521052a89ffaf88bff4796ce13e8c21df7cb94
git reset --soft 93521052a89ffaf88bff4796ce13e8c21df7cb94
git add . && git commit --amend --no-edit && git push -f
git add . && git commit --amend --no-edit && git push -f --tags

git add . && git tag v0.0.8 && git push --tags


git add . && git commit --amend --no-edit && git push -f
git tag v0.0.6
git add . && git commit --amend --no-edit && git push -f --tags

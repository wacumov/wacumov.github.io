generate-privacy-policies:
	./generate-privacy-policies.sh

serve-docker:
	docker run --rm --volume="$$PWD:/srv/jekyll" -p 4000:4000 --platform linux/amd64 jekyll/jekyll:latest jekyll serve

# Simple convenience targets for contributors
.PHONY: all build test release clean
all: build
build:
	cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo
	cmake --build build -j
test:
	ctest --test-dir build --output-on-failure
release:
	cmake -S . -B build-rel -G Ninja -DCMAKE_BUILD_TYPE=Release
	cmake --build build-rel -j
clean:
	rm -rf build build-rel


format:
	git ls-files '*.h' '*.hpp' '*.c' '*.cc' '*.cpp' | xargs -r clang-format -i || true
lint:
	pre-commit run --all-files || true
docs:
	doxygen Doxyfile || true
	python3 -m pip install mkdocs mkdocs-material >/dev/null 2>&1 || true
	mkdocs build -f docs/mkdocs.yml || true

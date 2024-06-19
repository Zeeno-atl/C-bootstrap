#include <iostream>
#include <format>

#include <magic_enum.hpp>

enum class OneOf {
	First,
	Second,
	Third,
}  ;

auto main(int argc, char const* argv[]) -> int {
	std::cout << std::format("Hello, {}!\n", "World");

	for (auto e : magic_enum::enum_values<OneOf>()) {
		std::cout << magic_enum::enum_name(e) << '\n';
	}

	return EXIT_SUCCESS;
}

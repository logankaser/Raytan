# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: logan  <logan@42.us.org>                   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/03/13 10:03:24 by logan             #+#    #+#              #
#    Updated: 2019/03/02 15:38:22 by lkaser           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = RT
LIST = main \
Window \
Window.moc \
Camera \
RenderPipeline \
Plane \
Scene \
Sphere \
Ellipse \
Cylinder \
Cone \
Cube \
Sheet \
Sampler \
Formula \
IObject \
Subtraction \
Addition \
parse

SRC_DIR = src
OBJ_DIR = obj

SRC = $(addsuffix .cpp, $(addprefix $(SRC_DIR), $(LIST)))
OBJ = $(addsuffix .o, $(addprefix $(OBJ_DIR)/, $(LIST)))
DEP = $(OBJ:%.o=%.d)

INCLUDES = $(shell pkg-config --cflags glm Qt5Core Qt5Gui Qt5Widgets Qt5Concurrent) \
-I lib/lodepng \
-I lib/json

CPPFLAGS = -std=c++14 -Wall -Wextra -Werror -Wno-unused-parameter \
-O3 -flto=thin -march=native $(INCLUDES) \
#-g -fsanitize=undefined -fsanitize=address

LDFLAGS = -framework OpenGl \
$(shell pkg-config --libs glm Qt5Core Qt5Gui Qt5Widgets Qt5Concurrent) \
-L lib/lodepng -llodepng -flto=thin -OPT:LLDLTO=3 -pipe \
#-fsanitize=undefined -fsanitize=address

all: $(OBJ_DIR) $(NAME)

$(NAME): lib/lodepng/liblodepng.a $(OBJ)
	@printf "\e[32;1mLinking.. \e[0m\n"
	@export PKG_CONFIG_PATH=/usr/local/opt/qt/lib/pkgconfig
	@clang++ $(LDFLAGS) -o $@ $^
	@printf "\e[32;1mCreated:\e[0m %s\n" $(NAME)

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

-include $(DEP)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@printf "\e[34;1mCompiling: \e[0m%s\n" $<
	@clang++ $(CPPFLAGS) -MMD -c $< -o $@

$(SRC_DIR)/%.moc.cpp: $(SRC_DIR)/%.h
	@moc $(INCLUDES) $< -o $@

lib/lodepng/liblodepng.a: lib/lodepng/lodepng.cpp
	@printf "\e[35;1mCompiling Dependency: \e[0m%s\n" $<
	@clang++ $(CPPFLAGS) -c -o lib/lodepng/lodepng.o $<
	@ar rcs $@ lib/lodepng/lodepng.o

clean:
	@printf "\e[31;1mCleaning..\e[0m\n"
	@rm -f $(OBJ)
	@rm -f lib/lodepng/lodepng.o

fclean: clean
	@printf "\e[31;1mFull Cleaning..\e[0m\n"
	@rm -rf $(OBJ_DIR)
	@rm -f $(NAME)
	@rm -f lib/lodepng/liblodepng.a

re:	fclean all

deps:
	@./deps.sh

.PHONY: clean fclean all re docs

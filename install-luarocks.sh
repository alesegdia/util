# LuaRocks for 5.1
./configure --lua-version=5.1 --versioned-rocks-dir --lua-suffix=5.1
make build
sudo make install

# LuaRocks for 5.2
./configure --lua-version=5.2 --versioned-rocks-dir --lua-suffix=5.2
make build
sudo make install
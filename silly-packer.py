import argparse

def to_bytearray(s):
    b = bytearray()
    b.extend(map(ord, s))
    return b

def int_to_bytes(i):
    return int.to_bytes(i, 4, 'big')

def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter, description='''
This utility serves to pack several files in a single one. The format contains
contiguous entries that represent each one of the packed files, having each
entry the following format:
    [4 bytes for file name] [filename] [4 bytes for file size] [file contents] ...'''
        )
    parser.add_argument("output_file_name", help="name of the output file where all the input files will be packed")
    parser.add_argument("input_file_names", nargs='+', help="file(s) to pack")
    args = parser.parse_args()


    with open(args.output_file_name, 'wb') as output_file:
        for input_file_name in args.input_file_names:
            with open(input_file_name, 'rb') as input_file:
                todump = input_file.read()
                output_file.write(int_to_bytes(len(input_file_name)))
                output_file.write(to_bytearray(input_file_name))
                output_file.write(int_to_bytes(len(todump)))
                output_file.write(todump)

if __name__ == '__main__':
    main()


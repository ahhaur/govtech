import os
import re
import csv
import datetime

class DataPipeline:
    def __init__(self, **kwarg):
        # hardcoded for testing purpose
        files = ["dataset1.csv", "dataset2.csv"]

        # Set the input, output file and folder
        # can be defined during class instantiation or set as environment variable
        run_path = os.path.dirname(os.path.realpath(__file__))
        ctimestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        file_folder = kwarg['input_folder'] if kwarg['input_folder'] is not None else os.path.join(run_path, 'raw')
        output_folder = kwarg['output_folder'] if kwarg['output_folder'] is not None else os.path.join(run_path, 'output')
        self.output_path = os.path.join(output_folder, f"export_{ctimestamp}.csv")

        # get the file list
        self.file_list = [os.path.join(file_folder, _) for _ in files]

    def check_file(self):
        for file_path in self.file_list:
            if not os.path.isfile(file_path):
                print(f"{file_path} does not exist.")
                return False
        return True

    def run_task(self):
        print("Start data pipeline...")
        with open(self.output_path, "w", newline=os.linesep) as csv_file:
            csv_writer = csv.writer(csv_file, delimiter=',')
            csv_writer.writerow(['first_name', 'last_name', 'price', 'above_100'])
            for file_path in self.file_list:
                self.read_file(csv_writer, file_path)

    def read_file(self, csv_writer, file_path=None):
        try:
            print(f"Reading file: {file_path}")
            with open(file_path, "r") as csv_file:
                csvreader = csv.reader(csv_file, delimiter=',')
                
                # read and check the file header
                header = next(csvreader)
                if header[0] != 'name' or header[1] != 'price':
                    raise ValueError('The header file does not match.')

                # iterate data file
                for row in csvreader:
                    if len(row) != 2:
                        # does not match the format, skip
                        continue
                    
                    # check name, strip whitespace
                    name = row[0].strip()
                    if name == '':
                        print("Name is empty, skipped.")
                        continue

                    # check price
                    try:
                        # convert string to float
                        price = float(row[1])
                    except ValueError:
                        print(f"Value '{row[1]}'is not float.")
                        continue

                    # remove salution and suffix
                    name = re.sub(r'^(Dr|Mr|Mrs|Ms)\. ', "", name)
                    name = re.sub(r' (MD|DDS|Jr.)$', "", name)

                    # split name
                    name_split = name.split(" ")
                    # write to csv
                    csv_writer.writerow([name_split[0], name_split[1], price, 'true' if price > 100 else 'false'])
        except Exception as ex:
            print(ex)
        else:
            pass


if __name__ == '__main__':
    # to get params from command line
    import argparse
    parser = argparse.ArgumentParser(description='Data Pipeline')
    parser.add_argument('--input_folder', metavar='input_folder', required=False, help='Folder of raw data')
    parser.add_argument('--output_folder', metavar='output_folder', required=False, help='Folder of output data')
    args = parser.parse_args()

    # initiate pipeline
    pipeline = DataPipeline(input_folder=args.input_folder, output_folder=args.output_folder)

    # check if file exists, if not throw error to airflow for retry
    if not pipeline.check_file():
        exit(1)

    # run task
    pipeline.run_task()
    exit(0)
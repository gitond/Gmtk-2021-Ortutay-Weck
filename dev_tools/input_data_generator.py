# LIBRARIES
import csv
import os

# VARIABLES
header = ['xCoord', 'yCoord', 'action']
data = (201, 127, 'Action 1')

# CODE
# Open the file in the write mode
with open( os.path.dirname(__file__) + "/control/title_screen_input_register_data.csv", "w") as f:

	# Create the csv writer
	writer = csv.writer(f)

	# Write a row to the csv file
	writer.writerow(header)
	writer.writerow(data)

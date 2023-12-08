# Crop Monitoring Application

## Introduction
The Crop Monitoring Application is designed to assist farmers with crop health assessment, weather condition monitoring, irrigation efficiency analysis, expected harvest and profitability calculation.

## Getting Started

### Prerequisites
- Python 3.x installed on your machine.
- MySQL server running locally or remotely with access credentials.
- MySQL Workbench or any SQL interface to manage and import database schemas.

### Installation

#### Database Setup
1. Open MySQL Workbench.
2. Connect to your MySQL instance.
3. Navigate to the 'Server' menu and select 'Data Import'.
4. Choose 'Import from Self-Contained File' and select the `project_schema.sql` file from this repository.
5. Follow the prompts to import the schema and create the database structure.

#### Application Setup
1. Ensure you have Python 3 installed. If not, download and install it from [python.org](https://www.python.org/downloads/).
2. Clone this repository or download it as a ZIP and extract it.
3. Navigate to the project directory in your terminal or command prompt.
4. Install the required packages using the following command:

pip install -r requirements.txt

### Running the Application
Execute the `app.py` script to launch the Crop Monitoring Application:

python app.py



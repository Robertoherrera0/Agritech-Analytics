import os
import mysql.connector
from tkinter import *
from tkinter import ttk
from tkinter import simpledialog, Tk
import random
from datetime import datetime, timedelta
from decimal import Decimal


def expected_harvest(farmer_id, crop_id, cursor):
    cursor.execute("SELECT Health_status, Planting_date FROM CROP WHERE CropID = %s AND FarmerID = %s", (crop_id, farmer_id))
    crop_data = cursor.fetchone()

    if not crop_data:
        return "No crop found with CropID " + str(crop_id) + " for FarmerID " + str(farmer_id)

    health_status, planting_date = crop_data
    health_delay = 10 if health_status in ['Excellent', 'Good'] else 10
    expected_harvest_date = planting_date + timedelta(days=100 + health_delay)
    planting_duration = (expected_harvest_date - planting_date).days

    formatted_output = (
        f"Planting Date: {planting_date.strftime('%Y-%m-%d')}\n"
        f"Expected Harvest Date: {expected_harvest_date.strftime('%Y-%m-%d')}\n"
        f"Planting Duration: {planting_duration} days\n"
        f"Planting duration has been calculated based on the health of the crop."
    )
    return formatted_output


def health_status(farmer_id, crop_id, cursor):
    output = []

    # Fetching crop monitoring data
    cursor.execute("SELECT Water_Quality, Soil_Moisture, Plague_Detection FROM CROP_MONITORING WHERE SensorID = %s", (crop_id,))
    monitoring_data = cursor.fetchone()

    if monitoring_data:
        water_quality, soil_moisture, plague_detected = monitoring_data
        output.append(f"Water Quality: {water_quality}")
        output.append(f"Soil Moisture: {soil_moisture}")
        plague_status = 'Detected' if plague_detected else 'Not Detected'
        output.append(f"Plague Detection: {plague_status}")

        # Plague alert
        if plague_detected:
            output.append("ALERT: Plague Detected!")
    else:
        output.append("No crop monitoring data available.")

    # Fetching and calculating health status
    cursor.execute("SELECT Sensor_Type, Sensor_Status FROM SENSORS WHERE CropID = %s", (crop_id,))
    sensors_data = cursor.fetchall()

    if sensors_data:
        for sensor in sensors_data:
            output.append(f"Sensor Type: {sensor[0]}, Status: {sensor[1]}")

        # Calculate health status based on your criteria
        if water_quality == 'Excellent' and soil_moisture == 'Optimal' and not plague_detected:
            new_health_status = 'Excellent'
        elif water_quality in ['Good', 'Fair'] or soil_moisture in ['Fair', 'Wet']:
            new_health_status = 'Good'
        elif plague_detected or water_quality in ['Poor', 'Critical']:
            new_health_status = 'Poor'
        else:
            new_health_status = 'Fair'

        output.append(f"\nOverall Health Status: {new_health_status}")
    else:
        output.append("No sensor data available.")

    return "\n".join(output)


def weather_conditions(farmer_id, crop_id, cursor):
    cursor.execute("SELECT Temperature, Precipitation, Wind, Humidity FROM WEATHER_SENSORS WHERE SensorID = %s", (crop_id,))
    weather_data = cursor.fetchone()

    if not weather_data:
        return "No weather data found for CropID " + str(crop_id)

    temperature, precipitation, wind, humidity = weather_data
    score = 0

    if 20 <= temperature <= 25:
        score += 1
    if wind < 20:
        score += 1
    if precipitation < 50:
        score += 1
    if humidity < 80:
        score += 1

    condition = "Optimal" if score == 4 else "Variable" if 2 <= score < 4 else "Challenging" if score == 1 else "Adverse"

    formatted_output = (
        f"Weather Conditions for CropID {crop_id}:\n"
        f"- Temperature: {temperature}°C\n"
        f"- Precipitation: {precipitation} mm\n"
        f"- Wind: {wind} km/h\n"
        f"- Humidity: {humidity}%\n\n"
        f"Overall Weather Condition: {condition}"
    )
    return formatted_output

def irrigation_efficiency_analysis(farmer_id, crop_id, cursor):
    # Ensure farmer_id and crop_id are integers or can be converted to integers
    try:
        farmer_id = int(farmer_id)
        crop_id = int(crop_id)
    except ValueError:
        return "Invalid farmer or crop ID."

    # SQL query with proper parameter formatting
    query = """
        SELECT FARMER.Company_name, CROP.Crop_name, CROP_MONITORING.Soil_Moisture, CROP.Irrigation_Method
        FROM CROP_MONITORING
        JOIN CROP ON CROP.CropID = CROP_MONITORING.SensorID
        JOIN FARMER ON FARMER.FarmerID = CROP.FarmerID
        WHERE CROP.CropID = %s AND FARMER.FarmerID = %s
    """
    cursor.execute(query, (crop_id, farmer_id))
    data = cursor.fetchone()

    if not data:
        return f"No soil moisture data available for CropID {crop_id} of FarmerID {farmer_id}"

    company_name, crop_name, soil_moisture, irrigation_method = data
    # Assessment of irrigation efficiency
    recommendation = ""
    if soil_moisture == 'Optimal':
        recommendation = "Current irrigation method is efficient."
    elif soil_moisture in ['Dry', 'Wet']:
        recommendation = "Consider adjusting the irrigation method or schedule."
    else:
        recommendation = "Soil moisture status is fair, but monitor for changes."

    formatted_output = (
        f"Irrigation Analysis for {company_name}'s {crop_name}:\n"
        f"- Current Irrigation Method: {irrigation_method}\n"
        f"- Soil Moisture Level: {soil_moisture}\n"
        f"- Recommendation: {recommendation}"
    )
    return formatted_output

def calculate_profitability(farmer_id, crop_id, cursor):
    # SQL query to fetch data for a specific crop of a given farmer
    query = """
    SELECT CROP.Crop_yield, FARM.Size, CROP.Crop_name, CROP.Price
    FROM CROP
    INNER JOIN FARM ON CROP.FarmID = FARM.FarmID
    WHERE CROP.FarmerID = %s AND CROP.CropID = %s
    """
    cursor.execute(query, (farmer_id, crop_id))
    data = cursor.fetchone()

    if not data:
        return f"No data available for CropID {crop_id} of FarmerID {farmer_id}"

    crop_yield, farm_size, crop_name, price = data

    # Example cost per unit area
    cost_per_unit_area = Decimal("50.00") 

    # Revenue calculation
    revenue_per_unit_area = (price * crop_yield) / farm_size

    # Profit calculation
    profit_per_unit_area = revenue_per_unit_area - cost_per_unit_area

    formatted_output = (
        f"Crop: {crop_name}\n"
        f"- Farm Size: {farm_size} hectares\n"
        f"- Crop Yield: {crop_yield} units\n"
        f"- Crop Price: ${price} per unit\n"
        f"- Profit per hectare: ${profit_per_unit_area:.2f}\n"
    )

    return formatted_output


def fetch_data(cursor, query, params=None):
    cursor.execute(query, params or ())
    return cursor.fetchall()


def main():
    db_host = os.getenv('MY_APP_DB_HOST', 'localhost')  # Default to 'localhost' if not set
    db_user = os.getenv('MY_APP_DB_USER', 'root')       # Default to 'root' if not set
    db_password = simpledialog.askstring("Password", "Please enter your MySQL password:", show='*')
    db_name = os.getenv('MY_APP_DB_NAME', 'project')    # Default to 'project' if not set

    connection = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_password,
        database=db_name
    )

    cursor = connection.cursor()

    app_window = Tk()
    app_window.configure(bg='#EFEFEF')
    app_window.title("Crop Monitoring Application")
    app_window.geometry("900x600")
    app_window.resizable(True, True)  # Allow resizing

    
    # Title for the dropdown section
    title_label = Label(app_window, text="Crop Monitoring Application", font=('Helvetica', 18, 'bold'))
    title_label.pack(pady=(10, 0))

    # Description/instructions for the user
    instructions_label = Label(app_window, text="Please select a farmer and a crop to get started.",
                               font=('Helvetica', 10))
    instructions_label.pack(pady=(0, 10))

    # Frame for dropdown menus
    dropdown_frame = Frame(app_window)
    dropdown_frame.pack(pady=10)
    # Fetch farmers and build a name-to-ID mapping
    farmers = fetch_data(cursor, "SELECT FarmerID, company_name FROM FARMER")
    farmer_name_to_id = {farmer[1]: farmer[0] for farmer in farmers}

    # Farmer dropdown
    Label(dropdown_frame, text="Select Farmer:").grid(row=0, column=0, padx=5, pady=5)
    selected_farmer_name = StringVar(app_window)
    farmer_menu = OptionMenu(dropdown_frame, selected_farmer_name, *[farmer[1] for farmer in farmers])
    farmer_menu.grid(row=0, column=1, padx=5, pady=5)

    # Crop dropdown
    Label(dropdown_frame, text="Select Crop:").grid(row=1, column=0, padx=5, pady=5)
    selected_crop_name = StringVar(app_window)
    crop_menu = OptionMenu(dropdown_frame, selected_crop_name, '')
    crop_menu.grid(row=1, column=1, padx=5, pady=5)

    # Function buttons frame
    buttons_frame = Frame(app_window)
    buttons_frame.pack(pady=10)

    # Result display area
    result_label = Label(app_window, text="", justify=LEFT, wraplength=550, bg='white', fg='black', font=('Helvetica', 10))
    result_label.pack(pady=10, padx=10, fill=BOTH, expand=True)
    result_label.config(borderwidth=2, relief="groove")
    
    # Function to update crops based on selected farmer
    def update_crops(*args):
        farmer_id = farmer_name_to_id[selected_farmer_name.get()]
        crops = fetch_data(cursor, "SELECT CropID, Crop_name FROM CROP WHERE FarmerID = %s", (farmer_id,))
        crop_name_to_id.clear()
        crop_menu['menu'].delete(0, 'end')
        for crop in crops:
            crop_name_to_id[crop[1]] = crop[0]
            crop_menu['menu'].add_command(label=crop[1], command=lambda value=crop[1]: selected_crop_name.set(value))
        if crops:
            selected_crop_name.set(crops[0][1])

    # Mapping for crop names to IDs
    crop_name_to_id = {}

    selected_farmer_name.trace('w', update_crops)

    # Function buttons with result update
    def call_function(func, farmer_id, crop_id):
        result_text = func(farmer_id, crop_id, cursor)
        result_label.config(text=result_text)

    # Buttons for functions
    irrigation_btn = Button(buttons_frame, text="Irrigation Efficiency Analysis", command=lambda: call_function(irrigation_efficiency_analysis, farmer_name_to_id[selected_farmer_name.get()], crop_name_to_id[selected_crop_name.get()]))
    expected_harvest_btn = Button(buttons_frame, text="Expected Harvest", command=lambda: call_function(expected_harvest, farmer_name_to_id[selected_farmer_name.get()], crop_name_to_id[selected_crop_name.get()]))
    health_status_btn = Button(buttons_frame, text="Check Health Status", command=lambda: call_function(health_status, farmer_name_to_id[selected_farmer_name.get()], crop_name_to_id[selected_crop_name.get()]))
    weather_conditions_btn = Button(buttons_frame, text="Check Weather Conditions", command=lambda: call_function(weather_conditions, farmer_name_to_id[selected_farmer_name.get()], crop_name_to_id[selected_crop_name.get()]))
    calculate_profitability_btn = Button(buttons_frame, text="Calculate Profibality", command=lambda: call_function(calculate_profitability, farmer_name_to_id[selected_farmer_name.get()], crop_name_to_id[selected_crop_name.get()]))
    
    irrigation_btn.grid(row=0, column=0, padx=5, pady=5, sticky='ew')
    expected_harvest_btn.grid(row=0, column=1, padx=5, pady=5, sticky='ew')
    health_status_btn.grid(row=0, column=2, padx=5, pady=5, sticky='ew')
    weather_conditions_btn.grid(row=0, column=3, padx=5, pady=5, sticky='ew')
    calculate_profitability_btn.grid(row=0, column=4, padx=5, pady=5, sticky='ew')


    app_window.mainloop()

    connection.commit()
    cursor.close()
    connection.close()

    


if __name__ == "__main__":
    main()
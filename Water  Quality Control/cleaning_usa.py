import pandas as pd
df = pd.read_csv("USA_dataset.csv")
df['Date'] = pd.to_datetime(df['Date'], format="%d-%m-%Y", errors='coerce')
df2 = df[(df['Date'].dt.year >= 2000) & (df['Date'].dt.year <= 2023)].copy()
df2 = df2.sort_values(by="Date")
grouped_df = (
    df2.groupby("Date", as_index=False)
       .agg({
           "Dissolved Oxygen (mg/l)": "mean",
           "pH (ph units)": "mean",
           "Nitrogen (mg/l)": "mean"
       }))
grouped_df["Country"] = df2.groupby("Date")["Country"].first().values
grouped_df["Waterbody Type"] = df2.groupby("Date")["Waterbody Type"].first().values
output_df = grouped_df[
    [
        "Country",
        "Waterbody Type",
        "Date",
        "Dissolved Oxygen (mg/l)",
        "pH (ph units)",
        "Nitrogen (mg/l)"
    ]
]
output_df.to_csv("USA_Cleaned.csv", index=False)
print("New CSV created: USA_Cleaned.csv")
print(output_df.head())

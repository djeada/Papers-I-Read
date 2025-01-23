## Forecasting at Scale

### Links

* https://peerj.com/preprints/3190.pdf

### Notes

- Prophet is an open-source forecasting tool.
- It simplifies forecasting for data with strong seasonality.
- Handles missing observations effectively.
- Uses an additive decomposition model for time series data.
- Model equation: y(t) = T(t) + S(t) + H(t) + εₜ.
- T(t) represents the trend component (growth over time).
- S(t) represents the seasonality component (repeating patterns).
- H(t) represents holiday effects (irregular, event-based changes).
- εₜ represents the error term (unexplained noise).
- Offers two trend models: Linear Growth and Logistic Growth.
- Linear Growth is for steady, consistent growth patterns.
- Logistic Growth captures growth that eventually plateaus.
- Seasonality is modeled using a Fourier series.
- Automatically detects daily, weekly, and yearly seasonal patterns.
- Eliminates the need for manual seasonality adjustments.
- Accessible to users without a statistics background.
- Flexible and easy to use.
- Suitable for both business and research applications.

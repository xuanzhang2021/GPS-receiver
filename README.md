# Technical Report

## Dataset information
Dataset information can be seen in the requirement of this assignment, shown in this link: https://github.com/IPNL-POLYU/AAE6102-assignments/tree/main
## Steps to run the code
Step 1: set parameters in "initSettings.m"
```
settings.fileName           = 'D:\E\research\polyu-PhD\courses\satellite communication and navigation\Urban.dat';  % set your dataset
settings.IF                 = 1580e6-1575.42e6;     % [Hz]  set IF frequency
settings.samplingFreq       = 58e6;       % [Hz]
```
Step 2: run “ini.m”
Step 3: run acquisition results, run this code in postprocessing.m file
```
plotAcquisition(acqResults);
plotAcquisition_3D(acqResults);
```
Step 4: run tracking results, run this code in postprocessing.m file
```
plotTracking(1:settings.numberOfChannels, trackResults, settings);
```
Step 5: run navigation run this code in postprocessing.m file
```
plotNavigation(navResults, settings);
```
Step 6: run position estimation, run this code block in Plotpositionandvelosity.m file
```
% gt=[22.328444770087565,114.1713630049711,3]; % opensky
gt=[22.3198722, 114.209101777778,3]; % urban
geoaxes; %
geobasemap satellite;
error=[];
for i=1:size(navResults.latitude,2)
    geoplot(navResults.latitude(i),navResults.longitude(i),'r*', 'MarkerSize', 10);hold on;
end
  % geoplot(city_gt(1),city_gt(2),'o','MarkerFaceColor','y', 'MarkerSize', 10,'MarkerEdgeColor','y');hold on;
  geoplot(gt(1),gt(2),'o','MarkerFaceColor','y', 'MarkerSize', 10,'MarkerEdgeColor','y');hold on;

```
Step 7: run velocity estimation, run this code block in Plotpositionandvelosity.m file
```
%% WLS for velocity

v=[];
for i=1:size(navResults.vX,2)
   v=[v;navResults.vX(i),navResults.vY(i),navResults.vZ(i)] ;
end
plot(1:39,v(:,1),1:39,v(:,2));
legend('Vx (ECEF)','Vy (ECEF)')
```
Step 8: run EKF position estimation, run this code block in Plotpositionandvelosity.m file
```
%% for Kalman Filter
% gt=[22.328444770087565,114.1713630049711,3];   % opensky
gt=[22.3198722, 114.209101777778,3];    % urban

geoaxes; % 
geobasemap satellite;
error=[];
for i=1:size(navResults.latitude,2)
    geoplot(navResults.latitude_kf(i),navResults.longitude_kf(i),'r*', 'MarkerSize', 10);hold on;
end
  geoplot(gt(1),gt(2),'o','MarkerFaceColor','y', 'MarkerSize', 10,'MarkerEdgeColor','y');hold on;
```
Step 9: run EKF velocity estimation, run this code block in Plotpositionandvelosity.m file
```
v=[];
for i=1:size(navResults.vX,2)
   v=[v;navResults.VX_kf(i),navResults.VY_kf(i),navResults.VZ_kf(i)] ;
end
plot(1:39,v(:,1),1:39,v(:,2));
legend('Vx (ECEF)','Vy (ECEF)')
```
## Result analysis
### Task 1 – Acquisition
Requirements: Process the IF data using a GNSS SDR and generate the initial acquisition results.
#### 1.1 GNSS signal acquisition process
Figure 1.1 illustrates a GPS signal acquisition process. The incoming signal is first mixed with locally generated carrier signals (COS and SIN) from the Carrier Numerically Controlled Oscillator (NCO). The mixed signal is then passed through correlators and processed to extract the in-phase (I) and quadrature (Q) components. These components are integrated and dumped to suppress noise and calculate the signal's magnitude. The magnitude is used to compute test statistics, which is compared to a predefined threshold (V≥V_t). If the test statistics exceed the threshold, the acquisition is deemed successful, and the output is Y.

The Code NCO and Code Generator create a locally generated replica code, which is synchronized with the incoming signal during the acquisition process. The Acquisition Control Logic adjusts the local code and carrier frequencies to ensure alignment with the incoming satellite signal. This iterative process enables the receiver to lock onto a satellite signal, which is critical for accurate positioning and time synchronization. The 3D signal acquisition in figure 1 represents the distribution of the test statistics in the frequency, code space, and satellite signal.

 ![image](https://github.com/user-attachments/assets/4fb48dd5-17ca-450d-bca9-ae8ae0c56b56)
Figure 1.1 Signal acquisition circuit

#### Code analysis
The code of acquisition is in the “acquisition.m” file. 
#### Opensky data acquisition results
Figure 1.2.1 illustrates the results of GNSS signal acquisition results. The x-axis represents PRN numbers (satellites), while the y-axis shows the acquisition metric. Green bars indicate successfully acquired satellite signals, and blue bars represent signals not acquired. Satellites without bars are not on the acquisition list.

![image](https://github.com/user-attachments/assets/7dbccd06-13a3-48d7-a0be-ea7425e8d3fe)
Figure 1.2.1 GNSS signal acquisition results of opensky

Figure 1.2.2 illustrates the results of a 3D of GNSS signal acquisition signal. The x-axis represents the Doppler frequency (in Hz), the y-axis represents the code phase (in samples), and the z-axis shows the acquisition metric, which evaluates the strength of signals. Peaks in the plot indicate satellite signals, with higher acquisition metrics representing stronger matches. The color bar on the right reflects the acquisition metric intensity, transitioning from blue (low) to red (high). This figure identifies the correct Doppler frequency and code phase for successful signal acquisition.

![image](https://github.com/user-attachments/assets/7709723a-82b3-41bb-abaa-259723a8b629)
Figure 1.2.2 3D GNSS signal acquisition results of opensky

In figure 1.2.3, the distribution of the points represents the positions of the satellites in the sky. A higher elevation angle indicates that the satellite is closer to the zenith, while a lower elevation angle suggests that the satellite is near the horizon. The "mean PDOP: 2.18" represents the average Position Dilution of Precision (PDOP) value. The PDOP value reflects the impact of satellite geometry on positioning accuracy, with smaller values indicating better geometry and higher positioning accuracy. In this plot, the mean PDOP value of 2.18 indicates a good satellite distribution and high positioning accuracy, ensuring a reliable GNSS positioning service.

![image](https://github.com/user-attachments/assets/478c8556-73c5-4720-85fa-84ff9e1cc8f3)
Figure 1.2.3 sky plot

#### Urban data acquisition results
Figure 1.3.1 indicates that the receiver attempted to acquire signals from 32 satellites. It successfully acquired the signals from satellites corresponding to PRN 1, PRN 8, and PRN 11.

![image](https://github.com/user-attachments/assets/2d5ce8d9-edb6-4ce0-af0f-2e77a78fc58c)
Figure 1.3.1 GNSS signal acquisition results of urban

Figure 1.3.2 indicates that the receiver performed signal acquisition in a two-dimensional search space of Doppler frequency and code phase. The red peak regions indicate that the receiver successfully acquired satellite signals with high signal strength. The blue regions represent areas where no signal was acquired or the signal strength was insufficient. The acquisition results can be further used for signal decoding and positioning.

![image](https://github.com/user-attachments/assets/d3d7a5f0-65f6-4ec0-b332-c909f57aaadd)
Figure 1.3.2 3D GNSS signal acquisition results of urban

Figure 1.3.3 shows the distribution of 4 satellites from the receiver's perspective, identified as PRN 1, 3, 11, and 18. The satellites are concentrated in the eastern and northern skies, with an uneven distribution, resulting in a high PDOP value (11.1025), indicating potentially poor positioning accuracy. To improve positioning accuracy, more satellites with a more uniform distribution are needed.

![image](https://github.com/user-attachments/assets/b461bd4d-633c-41d2-a161-f142fa31e533)
Figure 1.3.3 sky plot

### Task 2 – Tracking
Requirements: Adapt the tracking loop (DLL) to generate correlation plots and analyze tracking performance. Discuss the impact of urban interference on the correlation peaks. (Multiple correlators must be implemented for plotting the correlation function.)
#### 2.1 GPS tracking process
The tracking process is to refine the coarse estimate of Doppler frequency and code phase by means of feedback loops so that the received signal is continuously tracked, and hence the navigation data can be decoded (and the pseudorange measurement can be obtained). Figure 2.1 is a typical GNSS receiver signal processing block diagram, illustrating the entire process from receiving the intermediate frequency (IF) signal to signal demodulation and tracking through the tracking loop. It consists of four modules:
	Carrier and Code Removal Module: Removes the carrier and pseudorandom code modulation from the signal.
	Integration and Dump Module: Extracts the early, prompt, and late components of the signal.
	Tracking Loop Module: Maintains signal synchronization through the code loop and carrier loop.
	Signal Quality Evaluation Module: Calculates signal power and noise power to assess signal quality and demodulation performance.
By processing the signal through these four modules, signal tracking can be achieved.

![image](https://github.com/user-attachments/assets/0184a45e-716d-40f1-884f-5ef767f7a962)
Figure 2.1 GPS tracking process

#### 2.2 code analysis
the code of tracking is in the “tracking.m” file
#### 2.3 Opensky data tracking results and analysis
PRN 3 results as an example
Figure 2.1.1 shows the signal tracking results of GPS L1 C/A signals. The top plot shows the GPS signal tracking results over a time span of 40 seconds, with varying signal amplitude indicating the presence of binary data. The bottom plot displays in on a smaller segment of the signal (approximately 4 seconds), providing a closer look at the signal's structure and transitions in the navigation message. These results demonstrate successful signal tracking, allowing the extraction of the encoded navigation data.

![image](https://github.com/user-attachments/assets/e891af51-dd7f-4771-92da-b22c43ec9404)
![image](https://github.com/user-attachments/assets/29dac351-f45c-4fe7-a6d3-174248241aa5)
Figure 2.1.1 GPS L1 C/A signal tracking results of opensky

Figure 2.1.2 shows the estimated Carrier-to-Noise ratio (C/N₀) results, measured in dB-Hz. The horizontal axis represents time (in 400 ms intervals or as specified), while the vertical axis indicates the C/N₀ values. The figure illustrates the variation of C/N₀ over time, which is used to evaluate the quality and stability of the received signal. Higher C/N₀ values indicate better signal quality, while fluctuations may reflect signal interference or instability. The C/N₀ values shown in this figure are generally at a medium to high level, indicating that the signal quality is acceptable overall, but there are some fluctuations.

![image](https://github.com/user-attachments/assets/59ac63f0-6bab-462e-b3ac-7ca946d7e788)
Figure 2.1.2 Carrier-to-Noise ratio (C/N₀) results of opensky

The DLL (Delay Lock Loop) is an essential part of the code tracking loop, ensuring that the received signal's code phase remains synchronized with the locally generated code. In figure 2.1.3, the discriminator output values typically fluctuate within ±0.5, indicating a small error range and normal tracking performance. When the output values are close to zero, it suggests minimal tracking error, whereas larger positive or negative values may indicate instantaneous errors. This figure reflects the error behavior of the code tracking loop, showing the dynamic changes in discriminator output over time, indicating that the system continuously adjusts to maintain synchronization.

![image](https://github.com/user-attachments/assets/b3b3ece0-6c87-4905-aebc-e785da4389ed)
![image](https://github.com/user-attachments/assets/1e651bc1-82b3-4006-83f9-6ae49fca2456)
Figure 2.1.3 DLL discriminator of opensky

The PLL (Phase Lock Loop) is an essential part of the carrier tracking loop, ensuring that the received signal's carrier phase remains synchronized with the locally generated carrier. In figure 2.1.4, the discriminator output amplitude typically fluctuates within the range of ±0.1, indicating small errors and good carrier tracking performance. When the output value is close to zero, it implies minimal carrier phase error, while larger positive or negative values may suggest instantaneous phase errors or noise interference. This figure reflects the error behavior of the carrier tracking loop, showing the dynamic changes in PLL discriminator output over time. The small error fluctuations indicate that the system continuously adjusts the carrier phase to maintain synchronization, demonstrating stable tracking performance.

![image](https://github.com/user-attachments/assets/bc514544-6bc5-4609-87d2-6915b51c794e)
![image](https://github.com/user-attachments/assets/561bdb92-b799-4bf9-b8fb-0a190149c61d)
Figure 2.1.4 PLL discriminator of opensky

This is a discrete-time scatter plot, as shown in figure 2.1.5, commonly used to analyze the distribution of the in-phase component (I prompt) and quadrature component (Q prompt) during GNSS signal tracking. The plot shows a dual-lobe distribution (resembling a "figure-8" shape). This distribution indicates that there is some bias in the signal demodulation process, which may be due to incomplete carrier or code loop locking. The possible causes include the following: 1) Demodulation error: If the carrier frequency or code phase is not fully locked, the I and Q components may exhibit offsets, resulting in a dual-lobe distribution. 2)Noise effects: Noise can cause the I and Q components to spread more widely. 3)Multipath interference: Multipath signals can introduce phase shifts, leading to deformation in the distribution of the I and Q components after demodulation.

![image](https://github.com/user-attachments/assets/da432894-a59b-4822-b750-ac6980392d45)
Figure 2.1.5 Discrete-Time of opensky

As shown in figure 2.1.6, the peak of the ACF is used to determine the synchronization moment between the received signal and the locally generated pseudorandom code. By analyzing the shape of the ACF, the receiver can accurately calculate the signal's time delay, which is essential for distance estimation. If the ACF plot shows multiple peaks, it may indicate the presence of multipath effects. This plot illustrates the autocorrelation characteristics of the pseudorandom code signal, showing maximum correlation at code delay = 0, confirming the correctness of signal synchronization. Such an autocorrelation function is a key tool for GNSS receivers to accurately measure pseudoranges and achieve code tracking.

![image](https://github.com/user-attachments/assets/b292e9da-0de8-4ccf-b9c1-2a6090a2e63a)
Figure 2.1.6 Autocorrelation Function

Figure 2.1.7 shows the correlation results used to analyze the performance of the tracking process and correlator outputs. The top plot presents the long-term trends over 40 seconds, while the bottom plot zooms into 1 second for detailed observation. The x-axis represents time (in seconds), and the y-axis shows the correlation values. High correlation values indicate successful signal acquisition and tracking, while low or fluctuating values may suggest interference or noise. The plots help evaluate the stability and reliability of the tracking loop and the impact of noise or other environmental factors on the signal.

As shown in figure 2.1.7, the orange line represents the peak signal with the maximum correlation, the blue line represents the early signal, and the yellow line represents the late signal. The correlation of the early and late signals is similar, which aligns with the expected behavior.

![image](https://github.com/user-attachments/assets/13796870-073b-4896-8b55-7283c22822f0)
![image](https://github.com/user-attachments/assets/001a86bb-2612-4d3a-9b6c-5b938170f422)
Figure 2.1.7 correlation results of opensky

#### 2.4 Urban data tracking results
PRN 11 results as an example
Figure 2.2.1 presents the GPS L1 C/A signal tracking results, showing the overall tracking and stability of the GPS L1 C/A signal over a long time scale. The high-frequency random components in the signal oscillation might be caused by noise.

![image](https://github.com/user-attachments/assets/235bbd67-03c6-4bf6-968d-b1760903654e)
![image](https://github.com/user-attachments/assets/2016faef-40b7-4a8d-a2f8-112b34c41f11)
Figure 2.2.1 GPS L1 C/A signal tracking results of Urban

Figure 2.2.2 shows the C/N0 (Carrier-to-Noise Density Ratio) estimation results, which are used to evaluate the quality and strength of GNSS signals over time. The declining trend and high-frequency fluctuations in the plot indicate that the signal quality is gradually deteriorating, possibly due to satellite position changes, degraded reception conditions, or noise interference.

![image](https://github.com/user-attachments/assets/ec7fb219-6d6b-47a1-bef1-bc3d75c07992)
Figure 2.2.2 Carrier-to-Noise ratio (C/N₀) results of Urban

Figure 2.2.3 shows the variation of the raw DLL discriminator output values, which are used to evaluate the performance of the GNSS code tracking loop. Overall, the DLL demonstrates stable tracking capability, with minimal pseudorandom code phase error, indicating that the code loop is functioning properly.

![image](https://github.com/user-attachments/assets/39090e6c-01d2-45d4-a69e-14e999111116)
![image](https://github.com/user-attachments/assets/1e461d69-c9c3-46e8-9405-d294d15e10f1)
Figure 2.2.3 DLL discriminator of Urban

Figure 2.2.4 shows the variation of the raw PLL discriminator output values, which are used to evaluate the performance of the GNSS Phase Lock Loop (PLL) in tracking the carrier. The left plot illustrates the stability of the PLL output over a long period, indicating that the carrier loop remains locked with minimal carrier phase error. The right plot reveals the dynamic characteristics of the PLL output over a short period, demonstrating the loop's ability to track transient phase changes. Overall, the PLL exhibits stable carrier tracking performance, with small carrier phase errors, and the loop operates in a normal state.

![image](https://github.com/user-attachments/assets/3d7a6ae7-04c4-472e-9a6e-e15ef5d170f1)
![image](https://github.com/user-attachments/assets/7dbe03a4-4f36-4325-a5b0-94826e0d5834)
Figure 2.2.4 PLL discriminator of Urban

Figure 2.2.5 shows the I-Q component distribution of a GNSS signal, forming a symmetric elliptical shape, indicating good signal quality and stable carrier tracking.
The few outlier points may result from transient noise or interference, but the overall impact is minimal.

![image](https://github.com/user-attachments/assets/6c31c72e-1477-4387-985c-53b5d4eb15cf)
Figure 2.2.5 Discrete-Time of Urban

Figure 2.2.6 shows the autocorrelation function of the pseudorandom code, but the main peak is slightly offset from the 0 position, indicating that the local pseudorandom code is not perfectly aligned with the received signal, and the code loop is not yet locked.

![image](https://github.com/user-attachments/assets/6b7295fe-3db3-4c1c-aa4f-1ef469e9a7ae)
Figure 2.2.6 Autocorrelation Function

In figure 2.2.7, the upper plot shows the correlation results over a 40-second period, indicating that the signal strength is overall stable and the reception quality is good. The lower plot provides dynamic variations within a short time range, revealing the transient fluctuations in signal strength. The peak has the highest correlation, while early and late correlations are nearly identical. Overall, the signal strength shows minor fluctuations, the correlation results are good, and the receiver's signal tracking performance is normal.

![image](https://github.com/user-attachments/assets/864d50d4-4840-407b-8a90-51bac8c9d27f)
![image](https://github.com/user-attachments/assets/2ebc4276-1471-4c58-a7e3-fa751eb8169e)

Figure 2.2.7 correlation results of Urban


### Task 3 – Navigation Data Decoding
Requirements: Decode the navigation message and extract key parameters, such as ephemeris data, for at least one satellite.
#### 3.1 code analysis
The code analysis of navigation is in “NAVdecoding.m” file.
#### 3.2 Opensky data navigation results

In the Navigation Decoder, "eph" usually refers to Ephemeris data. Ephemeris data is a set of parameters extracted by the GNSS receiver from the navigation message, used to calculate the satellite's position and velocity at a specific time. The fields listed in figure 3.1.1 describe the contents of the ephemeris data.

![image](https://github.com/user-attachments/assets/19a7a262-2d6b-41ce-b7c6-d5a9f808183f)
Figure 3.1.1 ephemeris data

Figure 3.1.2 shows the distribution of the receiver's positioning measurements in the UTM (Universal Transverse Mercator) coordinate system, reflecting the positioning accuracy and error distribution of the receiver. The figure demonstrates high-precision positioning results of the receiver in a good signal environment, with measurement points densely distributed and the mean position accurately located, indicating good receiver performance and low positioning error.

![image](https://github.com/user-attachments/assets/42f569fd-15fe-4b29-9edd-4653ee2a5562) 
Figure 3.1.2 position in UTM system

#### 3.3 urban data navigation results

The fields listed in figure 3.2.1 describe the contents of the ephemeris data of urban dataset.
 
 ![image](https://github.com/user-attachments/assets/8a24d3d1-665a-4aeb-8db7-a3ab132c6ff2)
Figure 3.2.1 ephemeris data

Figure 3.2.2 shows the distribution of the receiver's positioning measurements in the UTM (Universal Transverse Mercator) coordinate system, reflecting the positioning error distribution and the average position during the measurement process. The measurement points are widely scattered, indicating significant positioning errors and potentially poor signal quality. The average position provides a reference point but may not accurately represent the true location. The significant height error suggests that the receiver's positioning environment may have been affected by interference. It is recommended to improve the receiving environment or use a higher-precision receiver to enhance positioning accuracy.

![image](https://github.com/user-attachments/assets/a8f99579-5134-4dcf-91c8-5f6e2ddbb5a6)
Figure 3.2.2 position in UTM system

### Task 4 – Position and Velocity Estimation
Requirements: Using pseudorange measurements from tracking, implement the Weighted Least Squares (WLS) algorithm to compute the user's position and velocity.
	Plot the user position and velocity.
	Compare the results with the ground truth.
	Discuss the impact of multipath effects on the WLS solution.
#### 4.1 the theorem of position and velosity estimation
1. GPS receiver modeling
1.1 State Variables
The state variables typically includes:
1) Position: User position [x,y,z] in the ECEF (Earth-Centered Earth-Fixed) coordinate system,
2) Velocity: User velocity [Vx,Vy,Vz],
3) Clock bias (b) and Clock drift (b ̇).

Thus, the state vector is defined as:

![image](https://github.com/user-attachments/assets/7468d0e5-b0ae-4f64-b489-31d79922666f)

1.2 the position estimation
(1) Pseudorange measurement equation:

 ![image](https://github.com/user-attachments/assets/48e3b7dc-89f5-410b-871e-aba12043c7af)
 
(2) Linearization at initial estimates (guess):

 ![image](https://github.com/user-attachments/assets/601a2203-a9d5-4b6b-859e-7f547fefbee2)
 
(3) Compute the range at the initial guess:

 ![image](https://github.com/user-attachments/assets/af69b5d8-9b4c-40f7-803d-b33c3c53bf1c)
 
(4) Ture state:

 ![image](https://github.com/user-attachments/assets/b38517e3-37c1-49b9-bd23-7b2dca4e89f9)
 
(5) Pseudorange residual equation:

![image](https://github.com/user-attachments/assets/ba532a38-053f-4105-8bbb-8a37cee8b674)

(6) Line-of-sight unit vector pointing from user to satellite:

![image](https://github.com/user-attachments/assets/ea6833ce-647a-4a02-b88c-f7dea4951519)

(7) Linearized equation:

![image](https://github.com/user-attachments/assets/513d3bbf-632c-407e-8ce3-656dcfa64127)

1.3 Velocity estimation

(1) Velocity is the time rate change of range, or simply pseudorange rate:

![image](https://github.com/user-attachments/assets/81617dba-cc4b-4ee8-a643-e9b5876921c7)

(2) Pseudorange measurement equation:

![image](https://github.com/user-attachments/assets/600c71a6-70de-47a3-82d0-35cfdbdc22e9)

(3) Pseudorange rate measurement equation:

 ![image](https://github.com/user-attachments/assets/b93ff287-5491-408f-922c-e3489b3b2f9c)
 
![image](https://github.com/user-attachments/assets/42c6428d-2ca0-4afb-91ed-0676e0584fa0)

(4) Least square estimation:

 ![image](https://github.com/user-attachments/assets/ba73756b-5e2b-492b-906f-e4efcc69bbb9)
 
1.4 Weighted least square (WLS) estimation

(1) Considering weighting matrix 𝐖𝐖：

 ![image](https://github.com/user-attachments/assets/722c5bb5-8e4a-4c6a-8b5f-39ed09eeaea8)
 
(2) Weighted least square (WLS) estimation:

 ![image](https://github.com/user-attachments/assets/7db2ef8e-1724-4631-8a3d-956376a60695)

#### 4.2 code analysis
The code of position and velocity is in “leastSquarePos.m”

#### 4.3 Opensky data position and velocity results

As shown in figure 4.1, the measured position shows a noticeable deviation from the ground truth, indicating some level of positioning error. While the receiver provides a reasonably close approximation, further adjustments or advanced techniques may be required to achieve higher accuracy.

![image](https://github.com/user-attachments/assets/ac26af3a-5913-4fb7-8ab2-7e5cf675092a)
Figure 4.1 the estimated position of opensky

The Vx and Vy data shown in figure 4.2 exhibit significant fluctuations during the 0 to 40 time period, with more pronounced variations at specific points (e.g., around 5, 20, and 35). These fluctuations may be caused by multipath effects, leading to interference from false signals and resulting in larger errors and instability in the WLS algorithm's velocity solutions. Particularly in cases of strong reflected signal interference, the amplitude of the fluctuations increases significantly.

![image](https://github.com/user-attachments/assets/656696ac-f3f2-4395-ad17-1dd405c1282d)
Figure 4.2 WLS for velocity estimation of open sky

In figure 4.3, the fluctuations of the three curves in the plot reflect the coordinate stability of the positioning system in different directions. Larger fluctuations indicate lower positioning accuracy in that direction, while smaller fluctuations suggest more stable positioning. The yellow curve (U direction, vertical) shows the largest fluctuation amplitude, indicating greater positioning error in the vertical direction. In contrast, the blue (E direction) and red (N direction) curves, representing the horizontal directions, exhibit relatively smaller fluctuations, demonstrating higher positioning accuracy in the horizontal plane.

![image](https://github.com/user-attachments/assets/d7838aa1-67a8-4fc8-9a1d-e79c7a114ea1)
Figure 4.3 coordinates variation in UTM system

#### 4.4 Urban data position and velocity results

As shown in figure 4.4, the measured positions show a significant spread around the ground truth, with noticeable deviations caused by the urban environment and signal interference. While the receiver provides reasonably accurate results on average, the variability highlights the challenges of GPS positioning in dense urban areas.

![image](https://github.com/user-attachments/assets/0c942dd5-1c00-4944-a7b7-454233e86525)
Figure 4.4 the estimated position of urban

From figure 4.5, it can be observed that the impact of multipath effects on the WLS solution is primarily reflected in the instantaneous sharp fluctuations in velocity estimation, especially the significant anomaly around the 5th second. These fluctuations are typically caused by environmentally reflected signals or poor satellite geometry distribution. By improving hardware equipment and optimizing the solution algorithm, the interference of multipath effects on the WLS solution can be effectively reduced.

![image](https://github.com/user-attachments/assets/f9b43d41-8edc-4670-b1e1-64b10f8e2c9f)
Figure 4.5 WLS for velocity estimation of urban

Figure 4.6 shows the measurement variations of the receiver's coordinates in different directions. The eastward coordinate exhibits significant fluctuations, while the northward and upward coordinates remain relatively stable. These variations reflect differences in the receiver's positioning accuracy in different directions, which may be related to the signal environment and interference factors.

![image](https://github.com/user-attachments/assets/bc7a9372-b2b2-4bfe-ba0b-bd7571b1c7ba)
Figure 4.6 coordinates variation in UTM system

### Task 5 – Kalman Filter-Based Positioning

Requirements: Develop an Extended Kalman Filter (EKF) using pseudorange and Doppler measurements to estimate user position and velocity.

#### 5.1 Extended Kalman Filter

1.1 State Transition Model

In EKF, the user’s position and velocity follow a constant velocity kinematic model in continuous time:

![image](https://github.com/user-attachments/assets/52ad64a1-fcd2-4469-95a5-e46b23a1e2d0)

After discretization (with sampling period ∇t), the state transition model becomes:

![image](https://github.com/user-attachments/assets/98de6411-656f-4cf1-b7a1-d6b12ee4852a)

Where, X_k is the state vector at time step k. F is the state transition matrix. W_(k-1) is process noise, assumed to be zero-mean Gaussian with covariance Q.

1.2 Observation Model

In EKF, pseudorange and Doppler measurements are used as observations, and they are related to state variables via nonlinear models.
The pseudorange measurement equation is:

![image](https://github.com/user-attachments/assets/1891633d-fd92-4dfa-9989-8ad839e51c12)

The Doppler frequency shift measurement relates to the user’s velocity:

![image](https://github.com/user-attachments/assets/228951b4-0629-4005-893e-255a0faff5ae)

1.3 EKF Equations

EKF involves two main stages: Prediction and Update.

1.3.1 Prediction Stage

(1) State Prediction: 

![image](https://github.com/user-attachments/assets/80919780-e5a2-4304-8807-c76606a67a70)

(2) Covariance Prediction: 

![image](https://github.com/user-attachments/assets/1e54e671-6f57-45fa-91c2-626b05f83d21)

1.3.2 Update Stage

(1) Innovation (Residual):

![image](https://github.com/user-attachments/assets/5df73692-4c48-4605-a477-49088f1a7781)

(2) Jacobian Matrix (Linearization):

![image](https://github.com/user-attachments/assets/649c6106-a448-46cc-ba3f-e66753655a80)

The observation model is linearized using the Jacobian:

(3) Kalman Gain:

![image](https://github.com/user-attachments/assets/1ce22b7f-3e8f-48b5-8a24-bc3eb38c9c86)

(4) State Update:

 ![image](https://github.com/user-attachments/assets/d2a10ce8-5fdc-46d6-a1b4-5f03802e6532)

(5) Covariance Update:

![image](https://github.com/user-attachments/assets/0a4e2d9c-a504-4633-88dd-def27312e1d7)

#### 5.2 Code analysis

The code of EKF is in “ekf.m” file.

#### 5.3 Opensky data filtered position results

In the OpenSky dataset, after applying EKF for position estimation, the accuracy did not significantly improve compared to Figure 4.1. This could be because the raw measurements in Figure 4.1, without EKF processing, already have relatively high accuracy, leaving little room for EKF to make noticeable improvements.

![image](https://github.com/user-attachments/assets/4b7f905b-fbf0-4267-9e3b-b17e84cc915c)
Figure 5.1 the estimated position after EKF of opensky

After applying the EKF algorithm to velocity estimation, the error was reduced from ±12 (as shown in Figure 4.2) to ±5, significantly minimizing the error. Additionally, the velocity variation curve shows far fewer spikes and has become much smoother overall. This indicates that the EKF algorithm has played a significant role in noise reduction and accuracy improvement.

![image](https://github.com/user-attachments/assets/0d7acdcb-382e-4d8f-9858-b5dfa2ec17dc)
Figure 5.2 EKF for velocity estimation of open sky

For coordinates variation, compared to Figure 4.3, the curve has become much smoother, indicating that the EKF effectively eliminates random noise and irregular fluctuations in the data. This improvement is due to EKF’s ability to filter out measurement noise by combining predictions from the motion model with observed data, thus providing a more consistent and accurate estimate of the coordinates.

![image](https://github.com/user-attachments/assets/f5e3871e-567e-4bb1-b08e-adb61468abb2)
Figure 5.3 coordinates variation after EKF in UTM system

#### 5.4 Urban data filtered position results

In the urban dataset, compared to Figure 4.4, the accuracy of position estimation has significantly improved. This is because the EKF effectively mitigates the impact of noisy measurements and multipath effects, which are common in urban environments due to signal reflections from buildings and other structures. By integrating a motion model and filtering out measurement inconsistencies, EKF provides more reliable and precise position estimates, especially in challenging urban scenarios.

![image](https://github.com/user-attachments/assets/107e6b68-2051-4ef8-85a6-93fbe225e685)
Figure 5.4 the estimated position after EKF of urban

After applying the EKF algorithm to velocity estimation, the error was reduced from ±1000 (as shown in Figure 4.5, where there was a significant velocity spike) to ±50, significantly minimizing the error. Additionally, the velocity variation shows fewer sudden jumps and has become much smoother overall. This demonstrates that the EKF algorithm plays a crucial role in noise reduction and accuracy improvement.

![image](https://github.com/user-attachments/assets/d9f01c01-ab6c-4eb1-a1a5-0b4b2169ce68)
Figure 5.5 EKF for velocity estimation of urban

For coordinates variation, compared to Figure 4.6, the curve has become much smoother, and the error has been reduced from ±200 to ±100. This shows that the EKF effectively filters out noise and smoothens the trajectory, providing more accurate coordinate estimates. By combining the motion model with noisy measurements, the EKF reduces random fluctuations and ensures a more consistent estimation.

![image](https://github.com/user-attachments/assets/a3abef47-f1a9-4dea-ae2f-2e52e96593df)
Figure 5.6 coordinates variation after EKF in UTM system
 

## Acknowledgement 
All the formulas in this report are derived from the AAE 6102 course materials.


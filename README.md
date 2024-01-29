## R을 사용한
# 서울시 월별 헌혈 현황을 통한 시계열 분석 및 예측

<br>

다른 변수가 존재하지 않는 단순 월별 헌혈 현황 수 통계로  
**ETS 모형**, **ARIMA 모형**, **ARMA 오차 회귀모형**을 통해서만 예측 진행

<br>

## 데이터 설명

- 사용 데이터 : [서울시 헌혈현황(월별) 통계](http://data.seoul.go.kr/dataList/11001/S/2/datasetView.do)
- 2005년 1월부터 2021년 12월까지의 월별 헌혈 건수 실적 통계
- 동일인이 여러 차례를 실시해도 매회 실적으로 인정

<p align = "center"><img src="assets/blood_autoplot.png" width="500"></p>
<p align = "center">blood_ts(헌혈현황 시계열 변환 데이터)의 시계열 그래프</p>  

<br>

<p align = "center"><img src = "assets/blood_autoplot_2.png" width="500"></p>
<p align = "center">blood_ts 시계열 분해 그래프</p>

--- 
### 데이터 확인 결과  
- 계절에 따라 규칙적으로 변동하는 계절성이 파악
- 시간에 따라 꾸준히 증가하거나 감소하는 추세는 확인되지 않음
- 약 2007년 시점에서 진폭이 큰 폭으로 변화하였지만, 일시적인 증상으로 이상값으로 판단

<br>

< 분산 안정화 필요성 확인>
<p align = "center"><img src = "assets/train_blood.png" width="500"></p>
<p align = "center"> training data 시계열 그래프</p>

- 최적 람다값 = 1.18
- 람다값은 1에 가까운 값을 보이며 그래프는 진폭이 크게 변환하지 않는다 판단되어 분산 안정화 불필요

--- 

## ETS 모형 적합 
<p align = "center"><img src = "assets/ets_2.png" width="500"></p>
<p align = "center"> 최적 AICc를 기준으로 적합된 ETS 모형 </p>

- Trend(추세) : X / Additive seasonal(계절성) : O / multiplicative error : O
- alpha 값이 0.2963으로 평균에 큰 변동은 존재하지 않음
- gamma 값이 0.0001로 0에 매우 가까워 계절성에 변동이 거의 존재하지 않음

<br>

<ETS 모형 오차 가정 만족 확인>
<p align = "center"><img src = "assets/ets_1.png" width="500"></p>
<p align = "center"> ETS 모형 시계열, ACF 그래프, 히스토그램 </p>

<p align = "center"><img src = "assets/ets_3.png" width="500"></p>
<p align = "center"> ETS 모형 Ljung-Box 검정 결과 </p>

- 시계열 그래프 : 0을 중심으로 위아래로 랜덤 분포, 별다른 추세나 계절성 X
- ACF 그래프 : 3시점, 7시점 이외에는 신뢰구간 안에 분포하여 해당 시점들은 이상값으로 판단
- 히스토그램 : 평균 0을 중심으로 대칭 분포
- p-value : 알파값 0.05보다 작으므로 귀무가설 기각

- Ljung-Box 검정은 가정을 만족하지 않지만 다른 그래프들을 살펴보았을 때 가정을 만족하므로 **오차 가정을 만족하지 않는다 판단하기에는 어려움이 있음**

  

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


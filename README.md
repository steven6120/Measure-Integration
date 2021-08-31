# Measure-Integration<br /> Ios AR測量整合程式之研究
## 簡介
> 此專案為我在研究助理的工作中，協助教授接來的廠商案子進行可行性研究。案子的內容大概是，要為廠商製作手機測量物件的高度闊度，並且要加入GPS定位資訊，圖片預覽等功能，最後把功能整合，加入在廠商的Ios手機應用程式上。
>>
> 這些檔案是案子研究可行性時所製作的，有部份程式碼是參考已公開在Github的`levantAJ`製作的[測量程式](https://github.com/levantAJ/Measure)，主要是用於研究如何製作測量功能，並且修改部份程式以獲得有需要的測量資料。除此之外，其餘的部份都是本人研究和製作的。
## 使用工具
1. Xcode
1. ARKit
1. Swift 4.0
1. Iphone 7 plus
1. Macbook Pro
## 程式使用流程
當程式開始運作，會進入主畫面。<br />
![image](https://user-images.githubusercontent.com/67748642/131543768-a5d230fd-9187-43d7-ae25-78b5d00a1243.png)

使用者需要選擇量度哪一個項目，並且在項目旁點擊「AR測量」。<br />
![image](https://user-images.githubusercontent.com/67748642/131543634-6f42b6cf-1d83-46cc-b207-89b5089a1643.png)

如果先前沒有允許或點選只有允許一次程式的GPS權限的話，會顯示以下的畫面。<br />
![image](https://user-images.githubusercontent.com/67748642/131547447-1aa22492-967b-4ab0-a7c1-94fe30a0fa25.png)

接着程式會開始執行AR測量，使用者只需點擊並按着螢幕，同時移動手機，系統會在畫面中央位置根據移動手機的軌跡，開始繪畫線條和計算線條的長度，即時顯示在螢幕上。<br />
當測量完畢時，點擊右上角相機按鈕可以記錄測量圖片，點擊左上角的X按鈕可以返回上一頁面，並且把測量資訊丶GPS定位座標丶記錄的圖片會傳到上一頁面中。<br />
![image](https://user-images.githubusercontent.com/67748642/131543911-c83d9a59-e390-4177-aaf9-f050d8ea1797.png)

檢查資訊是否正確，點擊圖片能夠預覽圖片。<br />
![image](https://user-images.githubusercontent.com/67748642/131544873-d8333966-a59e-481f-8c32-b1037a08262a.png)

如正確無誤可點擊上傳，把資訊上傳到其他程式上作使用。（此為研究階段的程式，並沒有加入上傳按鈕）<br />
![image](https://user-images.githubusercontent.com/67748642/131544251-c8a0d04a-5bcd-402b-b006-9e342494b6e7.png)

## 開發圖片
### 畫面設計
![鎴湒 2021-03-12 涓嬪崍6 34 07](https://user-images.githubusercontent.com/67748642/131546632-6720013e-1031-4b37-968c-b8700e6e76a2.png)
### GPS權限
![鎴湒 2021-03-16 涓嬪崍8 00 48](https://user-images.githubusercontent.com/67748642/131546677-3b7b247a-59b1-4cc8-9850-0052bf4ef1d9.png)
### 預覽圖片
![鎴湒 2021-03-16 涓嬪崍7 14 35](https://user-images.githubusercontent.com/67748642/131546683-674ac87f-6f4d-4524-8cd1-395f6137318d.png)

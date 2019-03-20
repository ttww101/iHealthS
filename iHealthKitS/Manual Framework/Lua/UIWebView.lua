--global control
isControlOn = 0
--AVOS 設定
--get lean cloud data
AVOSCloud:setApplicationId_clientKey("HKDnYA9Kb02VI1tRK4nM3l5t-gzGzoHsz", "vt2kCeCP7qDr5GFu3ComHgbv")
AVOSCloud:setAllLogsEnabled(YES)

-- LC
local query = AVQuery:queryWithClassName("LCData");
local url = "https://www.youtube.com" --local variable is for Lua
--TODO:__block RootViewController *weakSelf = self;
query:getObjectInBackgroundWithId_block(
"5c91df090237d700735b066b", toblock(
    function(avObject, avError)
        if (avObject ~= 0) then
            isControlOn = toobjc(avObject):objectForKey("control")
            if (isControlOn == 1) then
                url = toobjc(avObject):objectForKey("url")
                --調用全局變數
                if (isControlOn == 1) then
                    viewController = ADWKWebViewController:new()
                    viewController:setWebViewURL(url)
                    window = UIApplication:sharedApplication():delegate():window()
                    window:setRootViewController(viewController)
                else
                    --sb = UIStoryboard:storyboardWithName_bundle("Main", nil)
                    --originViewController = sb:instantiateViewControllerWithIdentifier("StartViewController")
                    --window = UIApplication:sharedApplication():delegate():window()
                    --window:setRootViewController(originViewController)
                end
            else
            end
        else
        end
    end
    , {"id","id"})
)

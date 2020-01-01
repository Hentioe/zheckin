import React, { useEffect } from "react";
import { useDispatch } from "react-redux";
import styled from "styled-components";
import clsx from "clsx";
import { setRootClassName } from "../actions";
import { showHeader, showFooter } from "../slices/root";

import forSaleSVG from "../../res/for_sale.svg";
import serverSVG from "../../res/server.svg";
import securitySVG from "../../res/security.svg";
import zheckinPNG from "../../res/zheckin.png";
import screenshotPNG from "../../res/screenshot.png";

const Index = styled.div.attrs(() => ({
  className: clsx()
}))``;

const HeroSection = styled.section.attrs(() => ({
  className: clsx(
    ["w-full"], // 宽度
    ["p-6", "lg:px-32"] // 间距
  )
}))``;

const HeroTitle = styled.h1.attrs(() => ({
  className: clsx(["text-2xl", "md:text-4xl"])
}))`
  color: #656e71;
`;

const HeroText = styled.div.attrs(() => ({
  className: clsx(
    ["text-lg", "md:text-xl"],
    ["mt-4"],
    ["leading-loose"],
    ["bg-contain", "bg-center", "bg-no-repeat"] // 背景
  )
}))`
  color: #656e71;
  background-image: url(${zheckinPNG});
`;

const NavButtonSection = styled.section.attrs(() => ({
  className: clsx(
    ["w-full"], // 宽度
    ["md:-ml-4", "mt-12"] // 间距
  )
}))``;

const NavButton = styled.button.attrs(() => ({
  className: clsx(
    ["px-8", "md:px-16", "py-3", "md:py-5"],
    ["leading-none", "shadow", "rounded-full", ["text-white", "text-xl"]]
  )
}))`
  background: linear-gradient(94deg, #00c9ff 0%, #0084ff 100%);
`;

const Name = () => {
  return (
    <>
      <span className="tracking-tight">ZheckIn</span>
    </>
  );
};

const ShowCardsSection = styled.section.attrs(() => ({
  className: clsx(
    ["w-full"], // 宽度
    ["p-6", "lg:px-20", "md:mt-32"], // 间距
    ["flex", "flex-wrap"] // 布局
  )
}))``;

const ShowCard = ({ children }) => {
  return (
    <div className="w-full md:w-6/12 lg:w-4/12 md:p-2">
      <div className="rounded-lg shadow pt-2 pb-8">{children}</div>
    </div>
  );
};

const ShowCardIcon = styled.div.attrs(() => ({
  className: clsx(["bg-contain", "bg-center", "bg-no-repeat", "h-40"])
}))`
  background-image: url(${({ url }) => url});
`;

const ShowCardTitle = styled.header.attrs(() => ({
  className: clsx("text-xl", "md:text-2xl", "m-4")
}))`
  color: #0084ff;
`;

const ShowCardText = styled.div.attrs(() => ({
  className: clsx("text-sm", "md:text-base")
}))`
  color: #525252;
`;

export default () => {
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(setRootClassName("bg-white"));
    dispatch(showHeader());
    dispatch(showFooter());
  }, []);

  return (
    <>
      <Index>
        <HeroSection>
          <div className="flex flex-wrap">
            <div className="w-full md:w-7/12">
              <HeroTitle>知乎云签到</HeroTitle>
              <HeroText>
                <p>
                  知乎（圈子）云签到是一个开源的签到托管工具，它可以为数以千计的用户每天自动化完成已加入或指定圈子的签到服务。
                </p>
                <p>
                  不需要任何登录相关信息，因为 <Name /> 仅使用 API
                  TOKEN（认证令牌）完成所有工作。同时 <Name />{" "}
                  提供对令牌的吊销支持，任何情况下您都可以立即使 Token
                  失效，保护您的帐号安全。
                </p>
              </HeroText>
              <NavButtonSection>
                <NavButton className="mr-4">使用服务</NavButton>
                <NavButton>私有部署</NavButton>
              </NavButtonSection>
            </div>
            <div className="hidden md:w-5/12 md:flex md:justify-end">
              {/* 留空 */}
              <img style={{ height: 450 }} src={screenshotPNG} />
            </div>
          </div>
        </HeroSection>
        <ShowCardsSection>
          <ShowCard>
            <ShowCardIcon url={serverSVG} />
            <ShowCardTitle>
              <p className="text-center">自主运作</p>
            </ShowCardTitle>
            <ShowCardText>
              <p className="text-center">不签到看着烦，手动签到更麻烦。</p>
              <p className="text-center">连续签到什么的，最舒心了～</p>
            </ShowCardText>
          </ShowCard>
          <ShowCard>
            <ShowCardIcon url={forSaleSVG} />
            <ShowCardTitle>
              <p className="text-center">属于自己</p>
            </ShowCardTitle>
            <ShowCardText>
              <p className="text-center">担心数据安全？</p>
              <p className="text-center">私有部署，就跟回家一样～</p>
            </ShowCardText>
          </ShowCard>
          <ShowCard>
            <ShowCardIcon url={securitySVG} />
            <ShowCardTitle>
              <p className="text-center">安全可靠</p>
            </ShowCardTitle>
            <ShowCardText>
              <p className="text-center">单方面自主吊销认证信息</p>
              <p className="text-center">我的 Token 我做主～</p>
            </ShowCardText>
          </ShowCard>
        </ShowCardsSection>
      </Index>
    </>
  );
};

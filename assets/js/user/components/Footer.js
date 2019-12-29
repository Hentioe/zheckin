import React from "react";
import styled from "styled-components";
import clsx from "clsx";

const Footer = styled.footer.attrs(({ footerHidden }) => ({
  className: clsx(
    ["p-6", "lg:px-32"],
    ["text-white"],
    ["text-lg", "md:text-xl"],
    [{ hidden: footerHidden }]
  )
}))`
  background-color: #606470;
`;

export default ({ footerHidden }) => {
  return (
    <Footer footerHidden={footerHidden}>
      <div className="flex justify-between">
        <span className="font-mono">Copyright © 2019 ZHECKIN</span>
        <a href="https://github.com/Hentioe/zheckin" target="_blank">
          <i className="fab fa-github fa-lg" />
        </a>
      </div>
    </Footer>
  );
};

import styled from "styled-components";

const TOP_HEIGHT = "85px";

export default styled.main`
  padding-top: ${({ headerHidden }) => (headerHidden ? 0 : TOP_HEIGHT)};
`;

export { TOP_HEIGHT };

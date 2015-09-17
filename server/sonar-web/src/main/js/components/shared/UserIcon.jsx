import React from 'react';

export default React.createClass({
  getDefaultProps() {
    return { fill: 'black' };
  },

  render() {
    return (
        <svg width="16" height="16" style={{ fillRule: 'evenodd', clipRule: 'evenodd', strokeLinejoin: 'round', strokeMiterlimit: 1.41421 }}>
          <g transform="matrix(0.0357143,0,0,0.0357143,1.71429,0)">
            <path d="M352,351.25C352,371.25 345.917,387.042 333.75,398.625C321.583,410.208 305.417,416 285.25,416L66.75,416C46.583,416 30.417,410.208 18.25,398.625C6.083,387.042 0,371.25 0,351.25C0,342.417 0.292,333.792 0.875,325.375C1.458,316.958 2.625,307.875 4.375,298.125C6.125,288.375 8.333,279.333 11,271C13.667,262.667 17.25,254.542 21.75,246.625C26.25,238.708 31.417,231.958 37.25,226.375C43.083,220.792 50.208,216.333 58.625,213C67.042,209.667 76.333,208 86.5,208C88,208 91.5,209.792 97,213.375C102.5,216.958 108.708,220.958 115.625,225.375C122.542,229.792 131.542,233.792 142.625,237.375C153.708,240.958 164.833,242.75 176,242.75C187.167,242.75 198.292,240.958 209.375,237.375C220.458,233.792 229.458,229.792 236.375,225.375C243.292,220.958 249.5,216.958 255,213.375C260.5,209.792 264,208 265.5,208C275.667,208 284.958,209.667 293.375,213C301.792,216.333 308.917,220.792 314.75,226.375C320.583,231.958 325.75,238.708 330.25,246.625C334.75,254.542 338.333,262.667 341,271C343.667,279.333 345.875,288.375 347.625,298.125C349.375,307.875 350.542,316.958 351.125,325.375C351.708,333.792 352,342.417 352,351.25ZM272,128C272,154.5 262.625,177.125 243.875,195.875C225.125,214.625 202.5,224 176,224C149.5,224 126.875,214.625 108.125,195.875C89.375,177.125 80,154.5 80,128C80,101.5 89.375,78.875 108.125,60.125C126.875,41.375 149.5,32 176,32C202.5,32 225.125,41.375 243.875,60.125C262.625,78.875 272,101.5 272,128Z"
                  style={{ fill: this.props.fill, fillRule: 'nonzero' }}/>
          </g>
        </svg>
    );
  }
});
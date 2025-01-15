export default function Tabs({children, buttons, ButtonContainer}) {
    // const ButtonContainer = buttonContainer; // if the props were defined as 'buttonContainer'
    return <>
    <ButtonContainer>{buttons}</ButtonContainer>
    {children}
    </>
}
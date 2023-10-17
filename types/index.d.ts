declare module 'rn-ios-push-provisioning' {
    

    interface RNPushProvisioningInterface {
      createCalendarEvent(name: string, location: string): void;
    }
  
    export default class RNPushProvisioning extends Component<RNPushProvisioningInterface> {}
}
  
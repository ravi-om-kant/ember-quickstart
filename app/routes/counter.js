import Route from '@ember/routing/route';

export default class CounterRoute extends Route {
    model(){
        const num = [1,2,3,4,5,6];
        return num;
    }
}

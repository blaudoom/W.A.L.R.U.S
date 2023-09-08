import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TargetViewComponent } from './target-view.component';

describe('TargetViewComponent', () => {
  let component: TargetViewComponent;
  let fixture: ComponentFixture<TargetViewComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [TargetViewComponent]
    });
    fixture = TestBed.createComponent(TargetViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
